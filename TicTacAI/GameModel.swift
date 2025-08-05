//
//  GameModel.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import Foundation

enum Player: String, CaseIterable, Equatable {
    case X = "X"
    case O = "O"
    
    var opposite: Player {
        return self == .X ? .O : .X
    }
}

enum GameMode {
    case twoPlayer
    case singlePlayerEasy
    case singlePlayerHard
}

enum GameState: Equatable {
    case ongoing
    case won(Player)
    case draw
}

class GameModel {
    private var board: [Player?] = Array(repeating: nil, count: 9)
    private(set) var currentPlayer: Player = .X
    private(set) var gameMode: GameMode = .twoPlayer
    private(set) var gameState: GameState = .ongoing
    
    init(mode: GameMode = .twoPlayer) {
        self.gameMode = mode
    }
    
    // MARK: - Game Logic
    
    func makeMove(at position: Int) -> Bool {
        guard position >= 0 && position < 9,
              board[position] == nil,
              gameState == .ongoing else {
            return false
        }
        
        board[position] = currentPlayer
        updateGameState()
        
        if gameState == .ongoing {
            currentPlayer = currentPlayer.opposite
            
            // If it's single player mode and now it's O's turn (AI), make AI move
            if (gameMode == .singlePlayerEasy || gameMode == .singlePlayerHard) && currentPlayer == .O {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeAIMove()
                }
            }
        }
        
        return true
    }
    
    private func makeAIMove() {
        let aiPosition: Int
        
        switch gameMode {
        case .singlePlayerEasy:
            aiPosition = getRandomMove()
        case .singlePlayerHard:
            aiPosition = getMinimaxMove()
        default:
            return
        }
        
        if aiPosition != -1 {
            board[aiPosition] = currentPlayer
            updateGameState()
            
            if gameState == .ongoing {
                currentPlayer = currentPlayer.opposite
            }
        }
    }
    
    private func getRandomMove() -> Int {
        let availableMoves = getAvailableMoves()
        guard !availableMoves.isEmpty else { return -1 }
        return availableMoves.randomElement() ?? -1
    }
    
    private func getMinimaxMove() -> Int {
        let availableMoves = getAvailableMoves()
        guard !availableMoves.isEmpty else { return -1 }
        
        var bestScore = Int.min
        var bestMove = availableMoves[0]
        
        for move in availableMoves {
            board[move] = .O
            let score = minimax(depth: 0, isMaximizing: false)
            board[move] = nil
            
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }
        
        return bestMove
    }
    
    private func minimax(depth: Int, isMaximizing: Bool) -> Int {
        let result = checkGameResult()
        
        if result == .won(.O) { return 10 - depth }
        if result == .won(.X) { return depth - 10 }
        if result == .draw { return 0 }
        
        if isMaximizing {
            var bestScore = Int.min
            for move in getAvailableMoves() {
                board[move] = .O
                let score = minimax(depth: depth + 1, isMaximizing: false)
                board[move] = nil
                bestScore = max(score, bestScore)
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for move in getAvailableMoves() {
                board[move] = .X
                let score = minimax(depth: depth + 1, isMaximizing: true)
                board[move] = nil
                bestScore = min(score, bestScore)
            }
            return bestScore
        }
    }
    
    private func getAvailableMoves() -> [Int] {
        return board.enumerated().compactMap { index, player in
            player == nil ? index : nil
        }
    }
    
    private func updateGameState() {
        gameState = checkGameResult()
    }
    
    private func checkGameResult() -> GameState {
        // Check rows
        for row in 0..<3 {
            let start = row * 3
            if let player = board[start],
               board[start] == board[start + 1] && board[start + 1] == board[start + 2] {
                return .won(player)
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if let player = board[col],
               board[col] == board[col + 3] && board[col + 3] == board[col + 6] {
                return .won(player)
            }
        }
        
        // Check diagonals
        if let player = board[0],
           board[0] == board[4] && board[4] == board[8] {
            return .won(player)
        }
        
        if let player = board[2],
           board[2] == board[4] && board[4] == board[6] {
            return .won(player)
        }
        
        // Check for draw
        if board.allSatisfy({ $0 != nil }) {
            return .draw
        }
        
        return .ongoing
    }
    
    // MARK: - Public Interface
    
    func getPlayer(at position: Int) -> Player? {
        guard position >= 0 && position < 9 else { return nil }
        return board[position]
    }
    
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .X
        gameState = .ongoing
    }
    
    func setGameMode(_ mode: GameMode) {
        gameMode = mode
        resetGame()
    }
}
