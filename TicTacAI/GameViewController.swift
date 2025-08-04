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
    
    // Game board buttons (3x3 grid)
    @IBOutlet var boardButtons: [UIButton]!
    
    // MARK: - Properties
    var gameMode: GameMode = .twoPlayer
    private var gameModel: GameModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupUI()
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
        for (index, button) in boardButtons.enumerated() {
            button.tag = index
            button.backgroundColor = .systemBackground
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemGray3.cgColor
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            button.setTitleColor(.label, for: .normal)
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(boardButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func boardButtonTapped(_ sender: UIButton) {
        let position = sender.tag
        
        if gameModel.makeMove(at: position) {
            updateBoardUI()
            updateGameStatus()
            
            // Check if game ended
            if case .won(_) = gameModel.gameState {
                showGameEndAlert()
            } else if case .draw = gameModel.gameState {
                showGameEndAlert()
            }
        }
    }
    
    private func updateBoardUI() {
        for (index, button) in boardButtons.enumerated() {
            if let player = gameModel.getPlayer(at: index) {
                button.setTitle(player.rawValue, for: .normal)
                button.setTitleColor(player == .X ? .systemBlue : .systemRed, for: .normal)
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.isEnabled = gameModel.gameState == .ongoing
            }
        }
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
