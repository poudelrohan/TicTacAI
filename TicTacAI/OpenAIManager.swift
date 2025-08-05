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
        print("🔍 Board sent to OpenAI:")
        print(boardString)
        
        // Create the prompt
        let prompt = createTicTacToePrompt(boardString: boardString)
        print("🤖 Full prompt sent to OpenAI:")
        print(prompt)
        
        // Make API request
        makeOpenAIRequest(prompt: prompt) { result in
            switch result {
            case .success(let response):
                if let position = self.parseAIResponse(response) {
                    // Validate the position is actually available
                    if board[position] == nil {
                        print("✅ OpenAI suggested valid empty position: \(position)")
                        completion(.success(position))
                    } else {
                        print("❌ OpenAI suggested occupied position \(position) - board[\(position)] = \(board[position]?.rawValue ?? "nil")")
                        completion(.failure(OpenAIError.invalidResponse))
                    }
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
        var availablePositions: [Int] = []
        
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
                result += "-"
                availablePositions.append(i)
            }
            
            if i % 3 != 2 {
                result += "|"
            }
        }
        
        result += "\n\nAVAILABLE POSITIONS: \(availablePositions.map(String.init).joined(separator: ", "))"
        return result
    }
    
    private func createTicTacToePrompt(boardString: String) -> String {
        return """
        You are playing Tic-Tac-Toe as player 'O'. The human is player 'X'.
        
        Current board:
        \(boardString)
        
        CRITICAL INSTRUCTIONS:
        - X = Human's move (OCCUPIED, cannot play here)
        - O = Your previous move (OCCUPIED, cannot play here)  
        - - = Empty space (you CAN play here)
        - You must choose from the AVAILABLE POSITIONS list only
        - If you suggest an occupied position, you lose the game
        
        Strategy priority: 1) Win immediately 2) Block human from winning 3) Take center/corners
        
        Respond with ONLY one number from the available positions.
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
        print("🔍 Raw OpenAI response: '\(response)'")
        
        // Extract number from response
        let cleanResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
        print("🧹 Cleaned response: '\(cleanResponse)'")
        
        // Try to parse as direct number
        if let position = Int(cleanResponse), position >= 0 && position <= 8 {
            print("✅ Parsed position directly: \(position)")
            return position
        }
        
        // Try to extract first number from response
        let numbers = cleanResponse.compactMap { char in
            char.isNumber ? Int(String(char)) : nil
        }
        print("🔢 Numbers found: \(numbers)")
        
        if let firstNumber = numbers.first, firstNumber >= 0 && firstNumber <= 8 {
            print("✅ Parsed position from numbers: \(firstNumber)")
            return firstNumber
        }
        
        print("❌ Failed to parse any valid position")
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
