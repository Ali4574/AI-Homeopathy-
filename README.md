# AI Homeopathy Intake System

A voice-enabled AI medical intake assistant specialized for homeopathic doctors. This application uses OpenAI's GPT-4o-mini model to conduct patient interviews through voice and text interactions.

## Features

- 🎤 **Voice Input**: Speech-to-text using Web Speech API
- 🔊 **Voice Output**: Text-to-speech for AI responses
- 💬 **Text Input**: Alternative typing interface
- 🏥 **Medical Intake**: Structured patient information collection
- ⚠️ **Urgency Detection**: Identifies red-flag symptoms
- 📱 **Responsive Design**: Works on desktop and mobile

## Quick Start

### Prerequisites
- Node.js 18 or higher
- OpenAI API key

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ai-homeopathy.git
   cd ai-homeopathy
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create environment file**
   ```bash
   # Create .env file
   nano .env
   ```
   
   Add your OpenAI API key:
   ```env
   OPENAI_API_KEY=sk-your-actual-api-key-here
   PORT=3000
   NODE_ENV=development
   ```

4. **Start the server**
   ```bash
   node server.js
   ```

5. **Open in browser**
   ```
   http://localhost:3000
   ```

## AWS Deployment

For production deployment on AWS Ubuntu, see [UBUNTU_DEPLOYMENT_GUIDE.md](UBUNTU_DEPLOYMENT_GUIDE.md)

### Quick AWS Setup
```bash
# On your Ubuntu EC2 instance
git clone https://github.com/your-username/ai-homeopathy.git
cd ai-homeopathy
nano .env  # Add your OpenAI API key
chmod +x deploy.sh
./deploy.sh
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `OPENAI_API_KEY` | Your OpenAI API key | Yes |
| `PORT` | Server port (default: 3000) | No |
| `NODE_ENV` | Environment (development/production) | No |

## Conversation Flow

The AI assistant follows this structured intake process:

1. **Greeting** and request for name, age, city
2. **Main symptoms** and duration
3. **Severity assessment** (1-10 scale)
4. **Red flag detection** (chest pain, breathlessness, etc.)
5. **General health** (appetite, thirst, sleep)
6. **Summary** of collected information

## Security Notes

- `.env` file is excluded from Git for security
- API keys should never be committed to version control
- Use HTTPS in production
- Implement proper authentication for production use

## Browser Compatibility

- **Voice Features**: Chrome, Edge, Safari (Web Speech API)
- **Text Features**: All modern browsers
- **Mobile**: iOS Safari, Chrome Mobile

## Troubleshooting

### Voice not working?
- Ensure you're using a supported browser
- Check microphone permissions
- Try refreshing the page

### API errors?
- Verify your OpenAI API key in `.env`
- Check your OpenAI account balance
- Ensure the API key has proper permissions

### Server won't start?
- Check if port 3000 is available
- Verify all dependencies are installed
- Check the `.env` file exists and is properly formatted

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the ISC License.

## Support

For issues and questions, please open an issue on GitHub.
