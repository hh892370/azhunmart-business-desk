# AzhunMart app setup — Hinglish

## Abhi code mein kya hai
- Email/password login
- Supabase database mein orders, ads, stock, expenses aur settings ka cloud save
- Har account ka data alag rakhne ke liye database security policies
- Daily CAC, delivered sales, estimated profit, COD/prepaid freight, RTO loss aur automatic stock calculations
- Gemini advisor ke liye secure server function; key server par rahegi

## Setup (ek baar)

### 1. Supabase project banao
Supabase par account/project banao. Project URL aur Publishable key (ya legacy anon key) milengi. **Secret/service-role key browser mein kabhi mat daalna.**

### 2. Database tayyar karo
Supabase ke SQL Editor mein `supabase/schema.sql` kholo, poora SQL copy karke Run karo. Isse app ki tables aur user-only security policies banengi.

### 3. Website host karo
Cloudflare Pages mein **Connect to Git** choose karke `hh892370/azhunmart-business-desk` select karo.
- Root directory: `app`
- Build command: blank
- Build output directory: `.`
Deploy ke baad Cloudflare tumhe `*.pages.dev` link dega. Abhi custom domain zaroori nahi.

### 4. Login configure karo
Supabase > Authentication > URL Configuration mein Site URL ko Cloudflare ka `https://...pages.dev` link set karo.
Cloudflare app kholo. Pehli baar Project URL aur Publishable/anon key enter karo. Create account dabao, apna email confirm karo, phir login karo. **Service-role key yahan kabhi mat daalna.**

Jab tumhara account ban jaye aur login test ho jaye, Supabase Auth settings se public sign-ups band kar do, taaki doosre log account na bana saken.

### 5. Gemini AI chalao
Supabase Edge Function `business-advisor` ko deploy karna hai aur Supabase Project Settings > Edge Functions > Secrets mein `GEMINI_API_KEY` save karni hai. Key ko chat, GitHub ya app ke kisi visible cell/code mein mat daalna.

Function deploy ke liye Supabase CLI aur project linking chahiye. Pehle Supabase project bana lo; uske baad deployment ko step-by-step set up kar sakte hain. API call quota/account ke mutabiq ho sakti hai; AI Studio mein current limits check karo.

## Yaad rakho
- Code public GitHub repo mein hai; usmein customer records ya secrets nahi hain.
- App login ke baad data cloud mein save karega, lekin backup download option bhi rakho.
- Abhi Shopify/Meta/WhatsApp/iThink/Shiprocket auto-sync aur CSV import nahi hai.
- Free plans mein limits/pausing ho sakti hai; roz ke business use se pehle provider plan check karna.

