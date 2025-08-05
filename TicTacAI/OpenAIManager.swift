//
//  OpenAIManager.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import Foundation

class OpenAIManager {
    static let shared = OpenAIManager()
    
    // MARK: - Configuration
    private let apiKey = Config.openAIAPIKey
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    private init() {}
    
    // MARK: - Public Interface
    func getAIMove(for board: [Player?], completion: @escaping (Result<Int, Error>) -> Void) {
        // Convert board to string representation
        let boardString = boardToString(board)
        
        // Create the prompt
        let prompt = createTicTacToePrompt(boardString: boardString)
        
        // Make API request
        makeOpenAIRequest(prompt: prompt) { result in
            switch result {
            case .success(let response):
                if let position = self.parseAIResponse(response) {
                    completion(.success(position))
                } else {
                    completion(.failure(OpenAIError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Helper Methods
    private func boardToString(_ board: [Player?]) -> String {
        var result = ""
        for i in 0..<9 {
            if i % 3 == 0 && i != 0 {
                result += "\n"
            }
            
            switch board[i] {
            case .X:
                result += "X"
            case .O:
                result += "O"
            case nil:
                result += "\(i)"
            }
            
            if i % 3 != 2 {
                result += "|"
            }
        }
        return result
    }
    
    private func createTicTacToePrompt(boardString: String) -> String {
        return """
        You are an expert Tic-Tac-Toe AI player. You are playing as 'O' and the human is 'X'.
        
        Current board state (numbers represent empty positions):
        \(boardString)
        
        Rules:
        1. You are 'O', human is 'X'
        2. Choose the best move for 'O'
        3. Respond with ONLY the position number (0-8)
        4. Priority: Win > Block opponent win > Strategic position
        
        What position (0-8) should 'O' play next? Respond with only the number.
        """
    }
    
    private func makeOpenAIRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(OpenAIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 50,
            "temperature": 0.3
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(OpenAIError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(OpenAIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func parseAIResponse(_ response: String) -> Int? {
        // Extract number from response
        let cleanResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to parse as direct number
        if let position = Int(cleanResponse), position >= 0 && position <= 8 {
            return position
        }
        
        // Try to extract first number from response
        let numbers = cleanResponse.compactMap { char in
            char.isNumber ? Int(String(char)) : nil
        }
        
        if let firstNumber = numbers.first, firstNumber >= 0 && firstNumber <= 8 {
            return firstNumber
        }
        
        return nil
    }
}

// MARK: - Error Types
enum OpenAIError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case apiKeyMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from API"
        case .invalidResponse:
            return "Invalid response format"
        case .apiKeyMissing:
            return "API key is missing"
        }
    }
}
