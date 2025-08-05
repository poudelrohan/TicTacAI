//
//  SettingsViewController.swift
//  TicTacAI
//
//  Created by Rohan Poudel on 8/4/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var mainStackView: UIStackView!
    
    // Player Names Section
    private var playerXNameTextField: UITextField!
    private var playerONameTextField: UITextField!
    
    // Game Settings Section
    private var soundEffectsSwitch: UISwitch!
    private var vibrationSwitch: UISwitch!
    private var animationsSwitch: UISwitch!
    
    // About Section
    private var appVersionLabel: UILabel!
    private var developerLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    // Action Buttons
    private var saveButton: UIButton!
    private var resetToDefaultsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCurrentSettings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "⚙️ Settings"
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContentView()
        setupMainStackView()
        setupPlayerNamesSection()
        setupGameSettingsSection()
        setupAboutSection()
        setupActionButtons()
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
    
    private func setupPlayerNamesSection() {
        let playerNamesSection = createSectionStackView()
        playerNamesSection.addArrangedSubview(createHeaderLabel(text: "👥 Player Names"))
        
        // Player X Name
        let playerXContainer = createTextFieldContainer()
        let playerXLabel = createFieldLabel(text: "Player X:")
        playerXNameTextField = createTextField(placeholder: "Enter Player X name")
        playerXContainer.addArrangedSubview(playerXLabel)
        playerXContainer.addArrangedSubview(playerXNameTextField)
        playerNamesSection.addArrangedSubview(playerXContainer)
        
        // Player O Name
        let playerOContainer = createTextFieldContainer()
        let playerOLabel = createFieldLabel(text: "Player O:")
        playerONameTextField = createTextField(placeholder: "Enter Player O name")
        playerOContainer.addArrangedSubview(playerOLabel)
        playerOContainer.addArrangedSubview(playerONameTextField)
        playerNamesSection.addArrangedSubview(playerOContainer)
        
        mainStackView.addArrangedSubview(playerNamesSection)
    }
    
    private func setupGameSettingsSection() {
        let gameSettingsSection = createSectionStackView()
        gameSettingsSection.addArrangedSubview(createHeaderLabel(text: "🎮 Game Settings"))
        
        // Sound Effects
        let soundContainer = createSwitchContainer()
        let soundLabel = createFieldLabel(text: "Sound Effects:")
        soundEffectsSwitch = createSwitch()
        soundContainer.addArrangedSubview(soundLabel)
        soundContainer.addArrangedSubview(soundEffectsSwitch)
        gameSettingsSection.addArrangedSubview(soundContainer)
        
        // Vibration
        let vibrationContainer = createSwitchContainer()
        let vibrationLabel = createFieldLabel(text: "Vibration:")
        vibrationSwitch = createSwitch()
        vibrationContainer.addArrangedSubview(vibrationLabel)
        vibrationContainer.addArrangedSubview(vibrationSwitch)
        gameSettingsSection.addArrangedSubview(vibrationContainer)
        
        // Animations
        let animationsContainer = createSwitchContainer()
        let animationsLabel = createFieldLabel(text: "Animations:")
        animationsSwitch = createSwitch()
        animationsContainer.addArrangedSubview(animationsLabel)
        animationsContainer.addArrangedSubview(animationsSwitch)
        gameSettingsSection.addArrangedSubview(animationsContainer)
        
        mainStackView.addArrangedSubview(gameSettingsSection)
    }
    
    private func setupAboutSection() {
        let aboutSection = createSectionStackView()
        aboutSection.addArrangedSubview(createHeaderLabel(text: "ℹ️ About TicTacAI"))
        
        // App Version
        appVersionLabel = createInfoLabel(text: "Version: 1.0.0")
        aboutSection.addArrangedSubview(appVersionLabel)
        
        // Developer
        developerLabel = createInfoLabel(text: "👨‍💻 Developer: Rohan Poudel")
        aboutSection.addArrangedSubview(developerLabel)
        
        // Description
        descriptionLabel = createInfoLabel(text: "🎯 A smart Tic-Tac-Toe game with AI opponents powered by OpenAI GPT. Play against easy, hard, or online AI opponents!")
        descriptionLabel.numberOfLines = 0
        aboutSection.addArrangedSubview(descriptionLabel)
        
        // Update version from bundle
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "📱 Version: \(appVersion)"
        }
        
        mainStackView.addArrangedSubview(aboutSection)
    }
    
    private func setupActionButtons() {
        let buttonSection = UIStackView()
        buttonSection.axis = .vertical
        buttonSection.spacing = 12
        buttonSection.distribution = .fillEqually
        
        // Save Button
        saveButton = UIButton(type: .system)
        saveButton.setTitle("💾 Save Settings", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveSettingsTapped), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Reset to Defaults Button
        resetToDefaultsButton = UIButton(type: .system)
        resetToDefaultsButton.setTitle("🔄 Reset to Defaults", for: .normal)
        resetToDefaultsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resetToDefaultsButton.backgroundColor = .systemOrange
        resetToDefaultsButton.setTitleColor(.white, for: .normal)
        resetToDefaultsButton.layer.cornerRadius = 12
        resetToDefaultsButton.addTarget(self, action: #selector(resetToDefaultsTapped), for: .touchUpInside)
        resetToDefaultsButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        buttonSection.addArrangedSubview(saveButton)
        buttonSection.addArrangedSubview(resetToDefaultsButton)
        
        mainStackView.addArrangedSubview(buttonSection)
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
    
    private func createFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }
    
    private func createInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }
    
    private func createTextFieldContainer() -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.distribution = .fill
        container.alignment = .center
        return container
    }
    
    private func createSwitchContainer() -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.distribution = .fill
        container.alignment = .center
        return container
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    private func createSwitch() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return switchControl
    }
    
    // MARK: - Settings Management
    private func loadCurrentSettings() {
        let stats = StatisticsManager.shared
        
        // Load player names
        playerXNameTextField.text = stats.playerXName
        playerONameTextField.text = stats.playerOName
        
        // Load game settings (from UserDefaults)
        soundEffectsSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundEffectsEnabled")
        vibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "VibrationEnabled")
        animationsSwitch.isOn = UserDefaults.standard.bool(forKey: "AnimationsEnabled")
        
        // Set defaults if first time
        if !UserDefaults.standard.bool(forKey: "SettingsInitialized") {
            soundEffectsSwitch.isOn = true
            vibrationSwitch.isOn = true
            animationsSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: "SettingsInitialized")
        }
    }
    
    @objc private func saveSettingsTapped() {
        print("💾 Saving settings...")
        
        // Save player names
        let playerXName = playerXNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let playerOName = playerONameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        StatisticsManager.shared.updatePlayerNames(
            playerX: playerXName.isEmpty ? "Player X" : playerXName,
            playerO: playerOName.isEmpty ? "Player O" : playerOName
        )
        
        // Save game settings
        UserDefaults.standard.set(soundEffectsSwitch.isOn, forKey: "SoundEffectsEnabled")
        UserDefaults.standard.set(vibrationSwitch.isOn, forKey: "VibrationEnabled")
        UserDefaults.standard.set(animationsSwitch.isOn, forKey: "AnimationsEnabled")
        
        // Show success feedback
        let alert = UIAlertController(
            title: "✅ Settings Saved",
            message: "Your preferences have been saved successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        print("✅ Settings saved successfully")
    }
    
    @objc private func resetToDefaultsTapped() {
        let alert = UIAlertController(
            title: "Reset to Defaults",
            message: "Are you sure you want to reset all settings to their default values?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.resetToDefaults()
        })
        
        present(alert, animated: true)
    }
    
    private func resetToDefaults() {
        // Reset player names
        playerXNameTextField.text = "Player X"
        playerONameTextField.text = "Player O"
        
        // Reset game settings
        soundEffectsSwitch.isOn = true
        vibrationSwitch.isOn = true
        animationsSwitch.isOn = true
        
        // Save defaults
        saveSettingsTapped()
        
        print("🔄 Settings reset to defaults")
    }
}
