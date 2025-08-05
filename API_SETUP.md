# 🔐 API Key Setup Instructions

## ⚠️ IMPORTANT: OpenAI API Key Configuration

This app uses OpenAI's GPT API for the "Online AI" game mode. To use this feature, you need to set up your own API key.

### 🚀 Quick Setup:

1. **Get your OpenAI API Key:**

   - Go to [OpenAI Platform](https://platform.openai.com/api-keys)
   - Create an account or sign in
   - Generate a new API key

2. **Configure the app:**

   - Copy `Config.template.swift` to `Config.swift`
   - Replace `"YOUR_OPENAI_API_KEY_HERE"` with your actual API key
   - Save the file

3. **Build and run:**
   - The "Online AI" mode will now work!
   - Without setup, the app falls back to local AI

### 🔒 Security Notes:

- ✅ `Config.swift` is automatically ignored by Git (never committed)
- ✅ Your API key stays private and secure
- ✅ The template file is safe to commit (no real keys)

### 💰 Cost Information:

- OpenAI charges per API call (~$0.001-0.002 per game)
- Very affordable for personal use
- The app includes smart fallbacks to local AI if API fails

### 🎮 Game Modes:

- **Two Player**: No API key needed
- **Single Player (Easy)**: Local AI - No API key needed
- **Single Player (Hard)**: Local AI - No API key needed
- **Single Player (Online)**: Requires API key ⚠️

Enjoy your AI-powered Tic-Tac-Toe game! 🎯
