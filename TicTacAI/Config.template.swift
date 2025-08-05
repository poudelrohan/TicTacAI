//
//  Config.template.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//  📋 SETUP INSTRUCTIONS: 
//  1. Copy this file to Config.swift
//  2. Replace "YOUR_OPENAI_API_KEY_HERE" with your actual OpenAI API key
//  3. Get your API key from: https://platform.openai.com/api-keys
//

import Foundation

struct Config {
    // ⚠️ SETUP REQUIRED: Replace with your OpenAI API key
    static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
    
    // Alternative secure approaches for production:
    // 1. Environment variables: ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    // 2. Keychain storage (recommended for production apps)
    // 3. External configuration service
}
