//
//  GameViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    // Game board buttons (3x3 grid) - Individual outlets
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    
    // Computed property to create array from individual outlets
    private var boardButtons: [UIButton] {
        return [button0, button1, button2, button3, button4, button5, button6, button7, button8].compactMap { $0 }
    }
    
    // MARK: - Properties
    var gameMode: GameMode = .twoPlayer
    private var gameModel: GameModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupUI()
        
        // Comprehensive connection diagnostics
        checkConnections()
    }
    
    private func checkConnections() {
        print("=== CONNECTION DIAGNOSTICS ===")
        
        // Check outlets
        let buttons = boardButtons
        print("📱 Board buttons connected: \(buttons.count) of 9")
        print("🏷️ Current player label: \(currentPlayerLabel != nil ? "✅ Connected" : "❌ Not connected")")
        print("📋 Game status label: \(gameStatusLabel != nil ? "✅ Connected" : "❌ Not connected")")
        print("🔄 Restart button: \(restartButton != nil ? "✅ Connected" : "❌ Not connected")")
        print("🏠 Home button: \(homeButton != nil ? "✅ Connected" : "❌ Not connected")")
        
        // Check individual button connections
        print("\n📋 Individual Button Connections:")
        print("  button0: \(button0 != nil ? "✅" : "❌")")
        print("  button1: \(button1 != nil ? "✅" : "❌")")
        print("  button2: \(button2 != nil ? "✅" : "❌")")
        print("  button3: \(button3 != nil ? "✅" : "❌")")
        print("  button4: \(button4 != nil ? "✅" : "❌")")
        print("  button5: \(button5 != nil ? "✅" : "❌")")
        print("  button6: \(button6 != nil ? "✅" : "❌")")
        print("  button7: \(button7 != nil ? "✅" : "❌")")
        print("  button8: \(button8 != nil ? "✅" : "❌")")
        
        // Check board button details
        if buttons.count > 0 {
            print("\n📋 Board Button Details:")
            for (index, button) in buttons.enumerated() {
                print("  Button \(index): Tag = \(button.tag), Title = '\(button.title(for: .normal) ?? "nil")'")
            }
        }
        
        // Check if all tags are unique and correct
        if buttons.count == 9 {
            let tags = buttons.map { $0.tag }.sorted()
            let expectedTags = Array(0...8)
            print("\n🏷️ Tag Analysis:")
            print("  Expected: \(expectedTags)")
            print("  Actual:   \(tags)")
            print("  Tags correct: \(tags == expectedTags ? "✅ Yes" : "❌ No")")
        }
        
        print("=== END DIAGNOSTICS ===\n")
    }
    
    private func setupGame() {
        gameModel = GameModel(mode: gameMode)
    }
    
    private func setupUI() {
        // Configure navigation
        navigationItem.hidesBackButton = true
        
        // Setup game status
        updateGameStatus()
        
        // Configure restart button
        restartButton.backgroundColor = .systemBlue
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.layer.cornerRadius = 8
        restartButton.setTitle("Restart", for: .normal)
        
        // Configure home button
        homeButton.backgroundColor = .systemGray
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.layer.cornerRadius = 8
        homeButton.setTitle("Home", for: .normal)
        
        // Setup board buttons
        setupBoardButtons()
    }
    
    private func setupBoardButtons() {
        let buttons = boardButtons
        print("✅ Setting up \(buttons.count) board buttons")
        
        guard buttons.count == 9 else {
            print("❌ ERROR: Expected 9 buttons, got \(buttons.count). Check storyboard connections.")
            return
        }
        
        for (index, button) in buttons.enumerated() {
            button.tag = index
            button.backgroundColor = .systemBackground
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemGray3.cgColor
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            button.setTitleColor(.label, for: .normal)
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(boardButtonTapped(_:)), for: .touchUpInside)
            
            print("  Configured button \(index) with tag \(button.tag)")
        }
    }
    
    @objc private func boardButtonTapped(_ sender: UIButton) {
        print("🎯 Board button tapped: \(sender.tag)")
        
        guard gameModel != nil else {
            print("❌ ERROR: gameModel is nil!")
            return
        }
        
        let position = sender.tag
        
        do {
            if gameModel.makeMove(at: position) {
                print("✅ Move successful at position \(position)")
                updateBoardUI()
                updateGameStatus()
                
                // Check if game ended
                if case .won(_) = gameModel.gameState {
                    showGameEndAlert()
                } else if case .draw = gameModel.gameState {
                    showGameEndAlert()
                }
            } else {
                print("⚠️ Move rejected at position \(position)")
            }
        } catch {
            print("❌ ERROR in boardButtonTapped: \(error)")
        }
    }
    
    private func updateBoardUI() {
        print("🔄 Updating board UI...")
        
        let buttons = boardButtons
        guard buttons.count == 9 else {
            print("❌ ERROR: Expected 9 buttons for board UI update, got \(buttons.count)")
            return
        }
        
        for (index, button) in buttons.enumerated() {
            if let player = gameModel.getPlayer(at: index) {
                button.setTitle(player.rawValue, for: .normal)
                button.setTitleColor(player == .X ? .systemBlue : .systemRed, for: .normal)
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.isEnabled = gameModel.gameState == .ongoing
            }
        }
        print("✅ Board UI updated successfully")
    }
    
    private func updateGameStatus() {
        switch gameModel.gameState {
        case .ongoing:
            let playerName = getPlayerName(for: gameModel.currentPlayer)
            currentPlayerLabel.text = "Current Player: \(playerName)"
            gameStatusLabel.text = "Game in progress..."
            gameStatusLabel.textColor = .label
        case .won(let player):
            let playerName = getPlayerName(for: player)
            currentPlayerLabel.text = "Game Over"
            gameStatusLabel.text = "\(playerName) Wins! 🎉"
            gameStatusLabel.textColor = .systemGreen
            
            // Record statistics
            StatisticsManager.shared.recordGameResult(mode: gameMode, result: gameModel.gameState)
        case .draw:
            currentPlayerLabel.text = "Game Over"
            gameStatusLabel.text = "It's a Draw! 🤝"
            gameStatusLabel.textColor = .systemOrange
            
            // Record statistics
            StatisticsManager.shared.recordGameResult(mode: gameMode, result: gameModel.gameState)
        }
    }
    
    private func getPlayerName(for player: Player) -> String {
        switch gameMode {
        case .twoPlayer:
            return player == .X ? StatisticsManager.shared.playerXName : StatisticsManager.shared.playerOName
        case .singlePlayerEasy, .singlePlayerHard:
            return player == .X ? "You" : "AI"
        }
    }
    
    private func showGameEndAlert() {
        let message: String
        
        switch gameModel.gameState {
        case .won(let player):
            let playerName = getPlayerName(for: player)
            message = "\(playerName) wins!"
        case .draw:
            message = "It's a draw!"
        case .ongoing:
            return
        }
        
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.restartGame()
        })
        
        alert.addAction(UIAlertAction(title: "Home", style: .cancel) { _ in
            self.goHome()
        })
        
        present(alert, animated: true)
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        restartGame()
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        goHome()
    }
    
    private func restartGame() {
        gameModel.resetGame()
        updateBoardUI()
        updateGameStatus()
    }
    
    private func goHome() {
        navigationController?.popViewController(animated: true)
    }
}
