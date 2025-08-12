# Git Setup and Deployment Guide

## Step 1: Initialize Git Repository (Local)

```bash
# Initialize Git repository
git init

# Add all files (except those in .gitignore)
git add .

# Make initial commit
git commit -m "Initial commit: AI Homeopathy Intake System"

# Add your remote repository
git remote add origin https://github.com/your-username/your-repo-name.git

# Push to GitHub
git push -u origin main
```

## Step 2: Verify .gitignore is Working

Before pushing, verify that sensitive files are excluded:

```bash
# Check what files will be committed
git status

# You should NOT see these files:
# - .env
# - node_modules/
# - package-lock.json (optional, you can include this)
```

## Step 3: AWS Deployment Workflow

### On Your AWS Ubuntu Server:

```bash
# 1. Clone your repository
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

# 2. Create .env file manually (this won't be in Git)
nano .env

# 3. Add your OpenAI API key to .env:
OPENAI_API_KEY=sk-your-actual-api-key-here
PORT=3000
NODE_ENV=production

# 4. Run deployment script
chmod +x deploy.sh
./deploy.sh
```

## Step 4: Updates and Maintenance

### When you make changes locally:

```bash
# 1. Make your changes
# 2. Test locally
node server.js

# 3. Commit and push
git add .
git commit -m "Description of changes"
git push origin main
```

### On AWS server to get updates:

```bash
# 1. Pull latest changes
git pull origin main

# 2. Install any new dependencies
npm install

# 3. Restart the application
pm2 restart ai-homeopathy
```

## Important Notes

### Security:
- ✅ `.env` file is excluded from Git
- ✅ `node_modules/` is excluded from Git
- ✅ API keys are never committed

### Files that WILL be in Git:
- `server.js` - Main server code
- `index.html` - Frontend interface
- `package.json` - Dependencies list
- `deploy.sh` - Deployment script
- `README.md` - Documentation
- `UBUNTU_DEPLOYMENT_GUIDE.md` - Deployment guide
- `.gitignore` - Git ignore rules

### Files that WON'T be in Git:
- `.env` - Environment variables (sensitive)
- `node_modules/` - Dependencies (large, can be reinstalled)
- `package-lock.json` - Lock file (optional)

## Troubleshooting

### If .env gets committed accidentally:
```bash
# Remove from Git but keep locally
git rm --cached .env
git commit -m "Remove .env file"
git push origin main
```

### If you need to update dependencies:
```bash
# Locally
npm install new-package
git add package.json package-lock.json
git commit -m "Add new dependency"
git push origin main

# On server
git pull origin main
npm install
pm2 restart ai-homeopathy
```

### If deployment fails:
```bash
# Check if .env exists
ls -la .env

# Check PM2 status
pm2 status

# Check logs
pm2 logs ai-homeopathy
```
