# Ubuntu AWS Deployment Guide for AI Homeopathy App

## Overview
This guide will help you deploy the AI Homeopathy Intake System to AWS Ubuntu EC2 instance.

## Prerequisites
- AWS Account
- SSH key pair for EC2 access
- OpenAI API key

## Step 1: Launch Ubuntu EC2 Instance

1. **Go to AWS Console → EC2 → Launch Instance**
2. **Choose Ubuntu Server 22.04 LTS** (free tier eligible)
3. **Instance Type**: t2.micro (free tier) or t3.small for better performance
4. **Key Pair**: Create or select existing SSH key pair
5. **Security Group**: Create new with these rules:
   - SSH (Port 22) from your IP
   - HTTP (Port 80) from anywhere
   - HTTPS (Port 443) from anywhere (optional)
   - Custom TCP (Port 3000) from anywhere

## Step 2: Connect to Your Ubuntu Instance

```bash
ssh -i your-key.pem ubuntu@your-instance-public-ip
```

## Step 3: Deploy the Application

### Option A: Using the Automated Script (Recommended)
```bash
# Download and run the deployment script
wget https://raw.githubusercontent.com/Ali4574/AI-Homeopathy-/main/deploy.sh
chmod +x deploy.sh
./deploy.sh
```

### Option B: Manual Installation
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Clone repository
git clone https://github.com/Ali4574/AI-Homeopathy-.git
cd AI-Homeopathy-

# Install dependencies
npm install
```

## Step 4: Start the Application

```bash
# Start with PM2
pm2 start server.js --name "ai-homeopathy"

# Make PM2 start on boot
pm2 startup
pm2 save

# Check status
pm2 status
```

## Step 5: Set Up Nginx (Optional)

```bash
# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure firewall
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
```

### Configure Nginx
```bash
sudo nano /etc/nginx/sites-available/ai-homeopathy
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com;  # or your EC2 public IP

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Enable the site
sudo ln -s /etc/nginx/sites-available/ai-homeopathy /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

## Step 6: Security Setup

### Update Security Group
- Only allow necessary ports (22, 80, 443, 3000)
- Restrict SSH access to your IP only

### Set Up SSL (Optional)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

## Step 7: Access Your Application

- **Direct**: http://your-ec2-public-ip:3000
- **With Nginx**: http://your-ec2-public-ip (port 80)
- **With SSL**: https://your-domain.com (if configured)

## Troubleshooting

### Check if server is running:
```bash
pm2 status
pm2 logs ai-homeopathy
```

### Check Nginx status:
```bash
sudo systemctl status nginx
sudo nginx -t
```

### Check firewall:
```bash
sudo ufw status
```

### Check environment variables:
```bash
# Test if .env is loaded
node -e "require('dotenv').config(); console.log('API Key:', process.env.OPENAI_API_KEY ? 'Set' : 'Not set')"
```

### Common Issues:

1. **Port 3000 not accessible**: Check security group and firewall
2. **API key not working**: Verify .env file and restart PM2
3. **Nginx not working**: Check configuration and reload

## Management Commands

```bash
# Restart application
pm2 restart ai-homeopathy

# Stop application
pm2 stop ai-homeopathy

# View logs
pm2 logs ai-homeopathy

# Monitor resources
pm2 monit

# Update application
git pull
npm install
pm2 restart ai-homeopathy
```

## Cost Optimization

- Use t2.micro for testing (free tier)
- Consider Spot Instances for cost savings
- Monitor usage with AWS CloudWatch
- Set up billing alerts

## Backup Strategy

- Regular backups of your code
- Database backups if you add one later
- Configuration backups
- Consider using AWS S3 for file storage

## Monitoring

- Set up CloudWatch alarms
- Monitor CPU, memory, and network usage
- Set up log aggregation
- Monitor API usage and costs
