# Backend API Deployment Guide for Render

## Prerequisites

1. Supabase account with PostgreSQL database
2. Render account
3. GitHub repository pushed with latest code

## Step-by-Step Deployment

### 1. Create Web Service on Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository: `Bhagyaholkade/Salesence`

### 2. Configure Service Settings

| Setting | Value |
|---------|-------|
| **Name** | `salesence-backend-api` |
| **Region** | Oregon (US West) |
| **Branch** | `main` |
| **Root Directory** | `salesenceeee/product-scraper` |
| **Runtime** | Node |
| **Build Command** | `chmod +x build.sh && ./build.sh` |
| **Start Command** | `cd apps/api && node dist/server.js` |
| **Instance Type** | Free |

### 3. Add Environment Variables

Click **"Advanced"** and add these environment variables:

#### Required Variables:

```
NODE_ENV=production
PORT=10000
DATABASE_URL=your_supabase_connection_string_here
```

#### Scraping Configuration:

```
SCRAPING_MODE=html
HEADLESS=true
MAX_RECOMMENDATIONS=8
SEARCH_PAGES_TO_FETCH=1
PRICE_BAND_PERCENTAGE=25
LOG_LEVEL=info
RATE_LIMIT_PER_DOMAIN_PER_SEC=0.5
MAX_RETRIES=3
USER_AGENTS_JSON=["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"]
```

### 4. Get Your Supabase Database URL

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Go to **Settings** → **Database**
4. Copy the **Connection String** (URI format)
5. Replace `[YOUR-PASSWORD]` with your actual database password
6. Use the **Connection Pooling** URL (ends with `:6543`)

Example format:
```
postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-region.pooler.supabase.com:6543/postgres
```

### 5. Deploy

1. Click **"Create Web Service"**
2. Wait for the build to complete (10-15 minutes first time)
3. Your API will be available at: `https://salesence-backend-api.onrender.com`

### 6. Verify Deployment

Test the health endpoint:
```bash
curl https://salesence-backend-api.onrender.com/health
```

Should return:
```json
{"status":"ok"}
```

## Troubleshooting

### Build Fails with "pnpm not found"

**Solution:** Make sure the build command includes `npm install -g pnpm`

### Playwright Installation Fails

**Solution:** Use the build.sh script which includes `--with-deps` flag

### Database Connection Fails

**Solution:** 
- Verify DATABASE_URL is correct
- Use the connection pooler URL (port 6543, not 5432)
- Check Supabase project is not paused

### API Returns 500 Errors

**Solution:**
- Check logs in Render dashboard
- Verify all environment variables are set
- Ensure Prisma client is generated (included in build)

## Update Frontend to Use Backend

After backend is deployed, update your frontend environment variable:

```
VITE_API_BASE_URL=https://salesence-backend-api.onrender.com
```

Then redeploy your frontend.

## Free Tier Limitations

- Service spins down after 15 minutes of inactivity
- First request after spin-down takes 30-60 seconds
- 750 hours/month free (enough for one service)

## Upgrade to Paid Plan

For production use, consider upgrading to:
- **Starter Plan ($7/month):** Always on, no spin down
- **Standard Plan ($25/month):** More resources, better performance

---

**Your backend API should now be live!** 🚀
