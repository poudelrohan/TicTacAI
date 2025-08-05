//
//  ViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiplayerButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        print("🏠 Setting up HomeViewController UI")
        title = "TicTacAI"
        
        // Check if outlets are connected
        guard titleLabel != nil else {
            print("❌ ERROR: titleLabel is not connected!")
            return
        }
        
        guard singlePlayerButton != nil && multiplayerButton != nil && 
              statisticsButton != nil && settingsButton != nil else {
            print("❌ ERROR: Some buttons are not connected!")
            print("   singlePlayerButton: \(singlePlayerButton != nil)")
            print("   multiplayerButton: \(multiplayerButton != nil)")
            print("   statisticsButton: \(statisticsButton != nil)")
            print("   settingsButton: \(settingsButton != nil)")
            return
        }
        
        // Configure title label
        titleLabel.text = "TicTacAI"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        
        // Configure buttons
        setupButton(singlePlayerButton, title: "Single Player", backgroundColor: .systemBlue)
        setupButton(multiplayerButton, title: "Multiplayer", backgroundColor: .systemGreen)
        setupButton(statisticsButton, title: "Statistics", backgroundColor: .systemOrange)
        setupButton(settingsButton, title: "Settings", backgroundColor: .systemGray)
        
        print("✅ HomeViewController UI setup completed")
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
    }
    
    // MARK: - IBActions
    @IBAction func singlePlayerTapped(_ sender: UIButton) {
        print("🎮 Single Player button tapped")
        showGameModeSelection()
    }
    
    @IBAction func multiplayerTapped(_ sender: UIButton) {
        print("👥 Multiplayer button tapped")
        navigateToGame(mode: .twoPlayer)
    }
    
    @IBAction func statisticsTapped(_ sender: UIButton) {
        print("📊 Statistics button tapped")
        navigateToStatistics()
    }
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        print("⚙️ Settings button tapped")
        navigateToSettings()
    }
    
    // MARK: - Navigation
    private func showGameModeSelection() {
        let alert = UIAlertController(title: "Single Player", message: "Choose difficulty level", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Easy", style: .default) { _ in
            self.navigateToGame(mode: .singlePlayerEasy)
        })
        
        alert.addAction(UIAlertAction(title: "Hard", style: .default) { _ in
            self.navigateToGame(mode: .singlePlayerHard)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = singlePlayerButton
            popover.sourceRect = singlePlayerButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func navigateToGame(mode: GameMode) {
        print("🎯 Attempting to navigate to GameViewController with mode: \(mode)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        do {
            if let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
                print("✅ GameViewController instantiated successfully")
                gameVC.gameMode = mode
                
                if let navController = navigationController {
                    navController.pushViewController(gameVC, animated: true)
                    print("✅ Navigation successful")
                } else {
                    print("❌ ERROR: navigationController is nil!")
                }
            } else {
                print("❌ ERROR: Could not instantiate GameViewController")
                print("   - Check Storyboard ID is set to 'GameViewController'")
                print("   - Check Custom Class is set to 'GameViewController'")
            }
        } catch {
            print("❌ ERROR in navigateToGame: \(error)")
        }
    }
    
    private func navigateToStatistics() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let statsVC = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController {
            navigationController?.pushViewController(statsVC, animated: true)
        }
    }
    
    private func navigateToSettings() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
}

