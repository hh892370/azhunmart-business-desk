# Free hosting — GitHub Pages setup

GitHub Pages uses this public repository to host the app at:
`https://hh892370.github.io/azhunmart-business-desk/`

## Enable it once
1. Open the repository on GitHub.
2. Click **Settings**.
3. In the sidebar, choose **Pages**.
4. Under **Build and deployment**, set **Source** to **Deploy from a branch**.
5. Set **Branch** to `main` and folder to `/(root)`, then click **Save**.
6. Wait for GitHub Pages to publish. The URL above will redirect to the app.

## Connect the app to the database
1. In Supabase, open **Authentication → URL Configuration**.
2. Set **Site URL** to `https://hh892370.github.io/azhunmart-business-desk/`.
3. Open the app. Enter the Supabase Project URL and **Publishable** key (not the secret/service-role key), create your account, confirm email, and log in.
4. After account creation, turn off public signups in Supabase Auth settings.

## AI setup is a separate step
Gemini requires the Supabase Edge Function to be deployed and the Gemini key saved as a Supabase Function Secret. This is not completed by enabling GitHub Pages. Do not put any secret key in GitHub or share it in chat.

The repository and GitHub Pages site are public. The site contains app code only; business records remain behind Supabase login and row-level security.
