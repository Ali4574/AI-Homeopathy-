#!/bin/bash

# AI Homeopathy App Deployment Script for Ubuntu
# Run this script on your AWS Ubuntu EC2 instance

echo "🚀 Starting AI Homeopathy App Deployment for Ubuntu..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js if not already installed
if ! command -v node &> /dev/null; then
    echo "📥 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js already installed: $(node --version)"
fi

# Install PM2 if not already installed
if ! command -v pm2 &> /dev/null; then
    echo "📥 Installing PM2..."
    sudo npm install -g pm2
else
    echo "✅ PM2 already installed"
fi

# Install dependencies
echo "📦 Installing project dependencies..."
npm install

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found!"
    echo "📝 Please create .env file manually with your OpenAI API key:"
    echo "   nano .env"
    echo ""
    echo "Example .env content:"
    echo "OPENAI_API_KEY=your-openai-api-key-here"
    echo "PORT=3000"
    echo "NODE_ENV=production"
    echo ""
    echo "After creating .env file, run this script again."
    exit 1
fi

# Start the application with PM2
echo "🚀 Starting application with PM2..."
pm2 start server.js --name "ai-homeopathy"

# Save PM2 configuration
echo "💾 Saving PM2 configuration..."
pm2 save

# Setup PM2 to start on boot
echo "🔧 Setting up PM2 to start on boot..."
pm2 startup

echo ""
echo "✅ Deployment completed!"
echo ""
echo "📊 Check application status:"
echo "   pm2 status"
echo ""
echo "📋 View logs:"
echo "   pm2 logs ai-homeopathy"
echo ""
echo "🌐 Your application should be running on:"
echo "   http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo ""
echo "🔧 To restart the application:"
echo "   pm2 restart ai-homeopathy"
echo ""
echo "🛑 To stop the application:"
echo "   pm2 stop ai-homeopathy"
