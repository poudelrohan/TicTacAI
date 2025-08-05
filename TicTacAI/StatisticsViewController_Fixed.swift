//
//  StatisticsViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var mainStackView: UIStackView!
    
    // Overall Stats
    private var totalGamesLabel: UILabel!
    private var totalDrawsLabel: UILabel!
    
    // Two Player Stats
    private var twoPlayerSectionLabel: UILabel!
    private var playerXWinsLabel: UILabel!
    private var playerOWinsLabel: UILabel!
    private var twoPlayerGamesLabel: UILabel!
    
    // Single Player Stats
    private var singlePlayerSectionLabel: UILabel!
    private var singlePlayerWinsLabel: UILabel!
    private var singlePlayerLossesLabel: UILabel!
    private var singlePlayerGamesLabel: UILabel!
    private var winRateLabel: UILabel!
    
    private var resetStatsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "📊 Statistics"
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContentView()
        setupMainStackView()
        setupStatisticsLabels()
        setupResetButton()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)
    }
    
    private func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
    }
    
    private func setupStatisticsLabels() {
        // Overall Stats Section
        let overallSection = createSectionStackView()
        overallSection.addArrangedSubview(createHeaderLabel(text: "📈 Overall Statistics"))
        
        totalGamesLabel = createStatLabel(text: "Total Games: 0")
        totalDrawsLabel = createStatLabel(text: "Total Draws: 0")
        
        overallSection.addArrangedSubview(totalGamesLabel)
        overallSection.addArrangedSubview(totalDrawsLabel)
        mainStackView.addArrangedSubview(overallSection)
        
        // Two Player Section
        let twoPlayerSection = createSectionStackView()
        twoPlayerSectionLabel = createHeaderLabel(text: "👥 Two Player Mode")
        twoPlayerSection.addArrangedSubview(twoPlayerSectionLabel)
        
        playerXWinsLabel = createStatLabel(text: "Player X Wins: 0")
        playerOWinsLabel = createStatLabel(text: "Player O Wins: 0")
        twoPlayerGamesLabel = createStatLabel(text: "Two Player Games: 0")
        
        twoPlayerSection.addArrangedSubview(playerXWinsLabel)
        twoPlayerSection.addArrangedSubview(playerOWinsLabel)
        twoPlayerSection.addArrangedSubview(twoPlayerGamesLabel)
        mainStackView.addArrangedSubview(twoPlayerSection)
        
        // Single Player Section
        let singlePlayerSection = createSectionStackView()
        singlePlayerSectionLabel = createHeaderLabel(text: "🤖 Single Player Mode")
        singlePlayerSection.addArrangedSubview(singlePlayerSectionLabel)
        
        singlePlayerWinsLabel = createStatLabel(text: "Your Wins: 0")
        singlePlayerLossesLabel = createStatLabel(text: "Your Losses: 0")
        singlePlayerGamesLabel = createStatLabel(text: "Single Player Games: 0")
        winRateLabel = createStatLabel(text: "Win Rate: 0%")
        
        singlePlayerSection.addArrangedSubview(singlePlayerWinsLabel)
        singlePlayerSection.addArrangedSubview(singlePlayerLossesLabel)
        singlePlayerSection.addArrangedSubview(singlePlayerGamesLabel)
        singlePlayerSection.addArrangedSubview(winRateLabel)
        mainStackView.addArrangedSubview(singlePlayerSection)
    }
    
    private func setupResetButton() {
        resetStatsButton = UIButton(type: .system)
        resetStatsButton.setTitle("🗑️ Reset All Statistics", for: .normal)
        resetStatsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        resetStatsButton.backgroundColor = .systemRed
        resetStatsButton.setTitleColor(.white, for: .normal)
        resetStatsButton.layer.cornerRadius = 12
        resetStatsButton.translatesAutoresizingMaskIntoConstraints = false
        resetStatsButton.addTarget(self, action: #selector(resetStatsTapped), for: .touchUpInside)
        
        mainStackView.addArrangedSubview(resetStatsButton)
        resetStatsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Main Stack View
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Helper Methods
    private func createSectionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }
    
    private func createHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }
    
    private func createStatLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }
    
    // MARK: - Statistics Update
    private func updateStatistics() {
        let stats = StatisticsManager.shared
        
        // Overall Statistics
        totalGamesLabel.text = "🎮 Total Games: \(stats.totalGamesPlayed)"
        totalDrawsLabel.text = "🤝 Total Draws: \(stats.totalDraws)"
        
        // Two Player Statistics
        playerXWinsLabel.text = "❌ Player X Wins: \(stats.twoPlayerWinsX)"
        playerOWinsLabel.text = "⭕ Player O Wins: \(stats.twoPlayerWinsO)"
        twoPlayerGamesLabel.text = "👥 Two Player Games: \(stats.twoPlayerWinsX + stats.twoPlayerWinsO)"
        
        // Single Player Statistics
        singlePlayerWinsLabel.text = "🏆 Your Wins: \(stats.singlePlayerWins)"
        singlePlayerLossesLabel.text = "😔 Your Losses: \(stats.singlePlayerLosses)"
        singlePlayerGamesLabel.text = "🤖 Single Player Games: \(stats.singlePlayerWins + stats.singlePlayerLosses)"
        
        // Calculate and display win rate
        let totalSinglePlayerGames = stats.singlePlayerWins + stats.singlePlayerLosses
        let winRate = totalSinglePlayerGames > 0 ? 
            (Double(stats.singlePlayerWins) / Double(totalSinglePlayerGames)) * 100.0 : 0.0
        winRateLabel.text = "📊 Win Rate: \(String(format: "%.1f", winRate))%"
        
        // Update win rate color based on performance
        if winRate >= 70 {
            winRateLabel.textColor = .systemGreen
        } else if winRate >= 50 {
            winRateLabel.textColor = .systemOrange
        } else {
            winRateLabel.textColor = .systemRed
        }
    }
    
    @objc private func resetStatsTapped() {
        let alert = UIAlertController(
            title: "Reset Statistics",
            message: "Are you sure you want to reset all statistics? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            StatisticsManager.shared.resetAllStatistics()
            self.updateStatistics()
            
            // Show success feedback
            let successAlert = UIAlertController(
                title: "✅ Reset Complete",
                message: "All statistics have been reset to zero.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
}
