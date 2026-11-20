# AzhunMart Business Desk

Single-user ecommerce management app for Website + WhatsApp orders.

## Included
- Email/password login through Supabase Auth.
- Cloud-saved orders, daily Meta Ads, stock, expenses, and business settings.
- Row Level Security: signed-in users can access only rows owned by their account.
- Order profit, COD/prepaid shipping, website fee, CAC, RTO losses, and stock calculations.
- Gemini advisor through an authenticated Supabase Edge Function. `GEMINI_API_KEY` stays server-side.
- JSON export backup.

## Deploy checklist

### 1. Create Supabase project
Create a project in Supabase. In **SQL Editor**, run `supabase/schema.sql`.
In Project Settings > API, copy the Project URL and the Publishable key (or legacy anon key). Do not use the secret/service-role key in the browser.

### 2. Deploy the app
In Cloudflare Pages, connect this GitHub repository. Set the root directory to `app`, leave build command blank, and use `.` as the output directory. The app is served from `app/index.html`.

### 3. Configure Supabase Auth
In Supabase Authentication > URL Configuration, set the Site URL to the deployed Cloudflare Pages URL. Keep email confirmation enabled. Create your owner account from the app, then disable public signups in Supabase Auth settings after you can sign in.

### 4. Connect from the app
Open the deployed app. Enter the Supabase Project URL and **Publishable/anon key**, create your account, confirm your email, and log in. The app saves business data in the Supabase database automatically.

### 5. Deploy the Gemini function
Install Supabase CLI, link the project, and deploy:

```sh
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase secrets set GEMINI_API_KEY=YOUR_GEMINI_KEY
supabase functions deploy business-advisor
```

Keep the Gemini key in Supabase secrets only. Never put it in the app, GitHub, or a spreadsheet cell. Then open **AI Advisor** in the app.

## Cost and operational notes
- Hosting, database, email delivery, and Gemini API usage are governed by their providers' current plans, quotas, pauses, and policies. Check those before relying on the app daily.
- Keep an occasional JSON backup even with cloud saving.
- This is a single-owner starter. Do not upload customer exports, backups, API keys, or production secrets to this public repository.
- CSV import, Shopify/Meta/WhatsApp/carrier live sync, and automated delivery webhooks are not included yet.

