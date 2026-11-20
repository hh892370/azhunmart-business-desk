import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status, headers: { ...cors, "Content-Type": "application/json" },
});

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "POST required" }, 405);
  const auth = req.headers.get("Authorization") || "";
  const token = auth.replace(/^Bearer\s+/i, "");
  if (!token) return json({ error: "Login required" }, 401);

  const publishableMap = Deno.env.get("SUPABASE_PUBLISHABLE_KEYS");
  const publishable = Deno.env.get("SUPABASE_ANON_KEY") || (publishableMap ? JSON.parse(publishableMap).default : "");
  const url = Deno.env.get("SUPABASE_URL");
  const geminiKey = Deno.env.get("GEMINI_API_KEY");
  if (!url || !publishable || !geminiKey) return json({ error: "Server setup incomplete" }, 500);

  const userClient = createClient(url, publishable, { global: { headers: { Authorization: `Bearer ${token}` } } });
  const { data: userData, error: userError } = await userClient.auth.getUser(token);
  if (userError || !userData.user) return json({ error: "Valid login required" }, 401);

  try {
    const body = await req.json();
    const summary = body?.summary;
    if (!summary || typeof summary !== "object") return json({ error: "Business summary required" }, 400);
    const serialized = JSON.stringify(summary);
    if (serialized.length > 40000) return json({ error: "Summary too large; reduce the data range" }, 413);

    const prompt = `You are a careful ecommerce business advisor. Reply in concise Hinglish. Use only supplied figures; do not invent facts. Give: key metrics, visible operational risks, and up to three practical actions. CAC is ad spend divided only by the user's recorded Meta-attributed orders. Do not claim Meta caused orders unless the data labels them attributed. Never ask for or reveal secrets.\n\nBUSINESS SUMMARY:\n${serialized}`;
    const response = await fetch("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent", {
      method: "POST",
      headers: { "Content-Type": "application/json", "x-goog-api-key": geminiKey },
      body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }], generationConfig: { temperature: 0.2, maxOutputTokens: 1000 } }),
    });
    const result = await response.json();
    if (!response.ok) return json({ error: result?.error?.message || "Gemini request failed" }, response.status);
    const advice = result?.candidates?.[0]?.content?.parts?.map((p: { text?: string }) => p.text || "").join("\n").trim();
    if (!advice) return json({ error: "Gemini returned no text" }, 502);
    return json({ advice });
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : "Unexpected error" }, 500);
  }
});

