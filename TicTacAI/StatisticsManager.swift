//
//  StatisticsManager.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import Foundation

class StatisticsManager {
    static let shared = StatisticsManager()
    
    private init() {}
    
    // MARK: - UserDefaults Keys
    private let playerXNameKey = "playerXName"
    private let playerONameKey = "playerOName"
    private let twoPlayerWinsXKey = "twoPlayerWinsX"
    private let twoPlayerWinsOKey = "twoPlayerWinsO"
    private let singlePlayerWinsKey = "singlePlayerWins"
    private let singlePlayerLossesKey = "singlePlayerLosses"
    private let totalGamesPlayedKey = "totalGamesPlayed"
    private let totalDrawsKey = "totalDraws"
    
    // MARK: - Player Names
    var playerXName: String {
        get { UserDefaults.standard.string(forKey: playerXNameKey) ?? "Player X" }
        set { UserDefaults.standard.set(newValue, forKey: playerXNameKey) }
    }
    
    var playerOName: String {
        get { UserDefaults.standard.string(forKey: playerONameKey) ?? "Player O" }
        set { UserDefaults.standard.set(newValue, forKey: playerONameKey) }
    }
    
    // MARK: - Statistics
    var twoPlayerWinsX: Int {
        get { UserDefaults.standard.integer(forKey: twoPlayerWinsXKey) }
        set { UserDefaults.standard.set(newValue, forKey: twoPlayerWinsXKey) }
    }
    
    var twoPlayerWinsO: Int {
        get { UserDefaults.standard.integer(forKey: twoPlayerWinsOKey) }
        set { UserDefaults.standard.set(newValue, forKey: twoPlayerWinsOKey) }
    }
    
    var singlePlayerWins: Int {
        get { UserDefaults.standard.integer(forKey: singlePlayerWinsKey) }
        set { UserDefaults.standard.set(newValue, forKey: singlePlayerWinsKey) }
    }
    
    var singlePlayerLosses: Int {
        get { UserDefaults.standard.integer(forKey: singlePlayerLossesKey) }
        set { UserDefaults.standard.set(newValue, forKey: singlePlayerLossesKey) }
    }
    
    var totalGamesPlayed: Int {
        get { UserDefaults.standard.integer(forKey: totalGamesPlayedKey) }
        set { UserDefaults.standard.set(newValue, forKey: totalGamesPlayedKey) }
    }
    
    var totalDraws: Int {
        get { UserDefaults.standard.integer(forKey: totalDrawsKey) }
        set { UserDefaults.standard.set(newValue, forKey: totalDrawsKey) }
    }
    
    // MARK: - Update Statistics
    func recordGameResult(mode: GameMode, result: GameState) {
        totalGamesPlayed += 1
        
        switch result {
        case .won(let player):
            switch mode {
            case .twoPlayer:
                if player == .X {
                    twoPlayerWinsX += 1
                } else {
                    twoPlayerWinsO += 1
                }
            case .singlePlayerEasy, .singlePlayerHard, .singlePlayerOnline:
                if player == .X {
                    singlePlayerWins += 1
                } else {
                    singlePlayerLosses += 1
                }
            }
        case .draw:
            totalDraws += 1
        case .ongoing:
            break
        }
    }
    
    // MARK: - Reset Statistics
    func resetAllStatistics() {
        twoPlayerWinsX = 0
        twoPlayerWinsO = 0
        singlePlayerWins = 0
        singlePlayerLosses = 0
        totalGamesPlayed = 0
        totalDraws = 0
    }
    
    // MARK: - Computed Properties
    var twoPlayerTotalGames: Int {
        return twoPlayerWinsX + twoPlayerWinsO
    }
    
    var singlePlayerTotalGames: Int {
        return singlePlayerWins + singlePlayerLosses
    }
    
    // MARK: - Player Name Management
    func updatePlayerNames(playerX: String, playerO: String) {
        playerXName = playerX
        playerOName = playerO
    }
}
