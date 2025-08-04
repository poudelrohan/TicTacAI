//
//  SettingsViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var playerNamesSectionLabel: UILabel!
    @IBOutlet weak var playerXNameTextField: UITextField!
    @IBOutlet weak var playerONameTextField: UITextField!
    
    @IBOutlet weak var aboutSectionLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCurrentSettings()
    }
    
    private func setupUI() {
        title = "Settings"
        
        // Configure section labels
        playerNamesSectionLabel.text = "Player Names"
        playerNamesSectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        aboutSectionLabel.text = "About"
        aboutSectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Configure text fields
        setupTextField(playerXNameTextField, placeholder: "Player X Name")
        setupTextField(playerONameTextField, placeholder: "Player O Name")
        
        // Configure about section
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "Version: \(appVersion)"
        } else {
            appVersionLabel.text = "Version: 1.0"
        }
        
        developerLabel.text = "Developer: Rohan Poudel"
        descriptionLabel.text = "TicTacAI is a classic tic-tac-toe game with AI opponents. Challenge yourself against different difficulty levels or play with friends!"
        descriptionLabel.numberOfLines = 0
        
        // Configure save button
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.setTitle("Save Settings", for: .normal)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.returnKeyType = .done
    }
    
    private func loadCurrentSettings() {
        let stats = StatisticsManager.shared
        playerXNameTextField.text = stats.playerXName
        playerONameTextField.text = stats.playerOName
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveSettings()
    }
    
    private func saveSettings() {
        let stats = StatisticsManager.shared
        
        // Update player names (with validation)
        if let playerXName = playerXNameTextField.text, !playerXName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            stats.playerXName = playerXName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let playerOName = playerONameTextField.text, !playerOName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            stats.playerOName = playerOName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Show confirmation
        let alert = UIAlertController(title: "Settings Saved", message: "Your settings have been saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        // Dismiss keyboard
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Auto-save when user finishes editing
        saveSettings()
    }
}
