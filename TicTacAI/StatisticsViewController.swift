//
//  StatisticsViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // Overall Stats
    @IBOutlet weak var totalGamesLabel: UILabel!
    @IBOutlet weak var totalDrawsLabel: UILabel!
    
    // Two Player Stats
    @IBOutlet weak var twoPlayerSectionLabel: UILabel!
    @IBOutlet weak var playerXWinsLabel: UILabel!
    @IBOutlet weak var playerOWinsLabel: UILabel!
    @IBOutlet weak var twoPlayerGamesLabel: UILabel!
    
    // Single Player Stats
    @IBOutlet weak var singlePlayerSectionLabel: UILabel!
    @IBOutlet weak var singlePlayerWinsLabel: UILabel!
    @IBOutlet weak var singlePlayerLossesLabel: UILabel!
    @IBOutlet weak var singlePlayerGamesLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    
    @IBOutlet weak var resetStatsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    private func setupUI() {
        title = "Statistics"
        
        // Configure section labels
        twoPlayerSectionLabel.text = "Two Player Mode"
        twoPlayerSectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        singlePlayerSectionLabel.text = "Single Player Mode"
        singlePlayerSectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Configure reset button
        resetStatsButton.backgroundColor = .systemRed
        resetStatsButton.setTitleColor(.white, for: .normal)
        resetStatsButton.layer.cornerRadius = 8
        resetStatsButton.setTitle("Reset All Statistics", for: .normal)
    }
    
    private func updateStatistics() {
        let stats = StatisticsManager.shared
        
        // Overall statistics
        totalGamesLabel.text = "Total Games Played: \(stats.totalGamesPlayed)"
        totalDrawsLabel.text = "Total Draws: \(stats.totalDraws)"
        
        // Two player statistics
        playerXWinsLabel.text = "\(stats.playerXName) Wins: \(stats.twoPlayerWinsX)"
        playerOWinsLabel.text = "\(stats.playerOName) Wins: \(stats.twoPlayerWinsO)"
        twoPlayerGamesLabel.text = "Two Player Games: \(stats.twoPlayerTotalGames)"
        
        // Single player statistics
        singlePlayerWinsLabel.text = "Your Wins: \(stats.singlePlayerWins)"
        singlePlayerLossesLabel.text = "AI Wins: \(stats.singlePlayerLosses)"
        singlePlayerGamesLabel.text = "Single Player Games: \(stats.singlePlayerTotalGames)"
        
        // Calculate win rate
        let winRate: Double
        if stats.singlePlayerTotalGames > 0 {
            winRate = Double(stats.singlePlayerWins) / Double(stats.singlePlayerTotalGames) * 100
            winRateLabel.text = String(format: "Win Rate: %.1f%%", winRate)
        } else {
            winRateLabel.text = "Win Rate: --"
        }
    }
    
    @IBAction func resetStatsButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Reset Statistics",
            message: "Are you sure you want to reset all statistics? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            StatisticsManager.shared.resetAllStatistics()
            self.updateStatistics()
        })
        
        present(alert, animated: true)
    }
}
