# TicTacAI

A modern UIKit-based iOS tic-tac-toe game with AI opponents.

## Features

- **Two Player Mode**: Classic tic-tac-toe for two players on one device
- **Single Player Mode**: Play against AI with two difficulty levels:
  - **Easy**: Random AI moves
  - **Hard**: Minimax algorithm AI (unbeatable)
- **Statistics Tracking**: Comprehensive game statistics using UserDefaults
- **Customizable Player Names**: Personalize your gaming experience
- **Clean UI**: Modern iOS design with smooth animations

## Screenshots

_(Add screenshots of your app here)_

## Architecture

### MVC Pattern

The app follows the Model-View-Controller design pattern:

- **Model**: `GameModel.swift`, `StatisticsManager.swift`
- **View**: Storyboard scenes and custom UI components
- **Controller**: Various ViewControllers for different screens

### Key Components

1. **GameModel**: Core game logic including:

   - Board state management
   - Move validation
   - Win/draw detection
   - AI implementation (random and minimax)

2. **StatisticsManager**: Persistent data storage using UserDefaults:

   - Player names
   - Win/loss statistics
   - Game counts

3. **View Controllers**:
   - `HomeViewController`: Main menu
   - `GameViewController`: Game board and gameplay
   - `StatisticsViewController`: Statistics display
   - `SettingsViewController`: App configuration

## AI Implementation

### Easy Mode

Uses random move selection from available positions.

### Hard Mode

Implements the Minimax algorithm:

- Recursively evaluates all possible game states
- Chooses optimal moves to maximize AI's chances
- Provides challenging gameplay (AI never loses)

## Data Persistence

Statistics are stored using UserDefaults with the following keys:

- Player names: `playerXName`, `playerOName`
- Two-player stats: `twoPlayerWinsX`, `twoPlayerWinsO`
- Single-player stats: `singlePlayerWins`, `singlePlayerLosses`
- Overall stats: `totalGamesPlayed`, `totalDraws`

## Setup Instructions

1. Clone the repository
2. Open `TicTacAI.xcodeproj` in Xcode
3. Build and run on your iOS device or simulator

### Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Project Structure

```
TicTacAI/
├── AppDelegate.swift
├── SceneDelegate.swift
├── GameModel.swift           # Core game logic and AI
├── StatisticsManager.swift   # Data persistence
├── HomeViewController.swift  # Main menu (renamed from ViewController.swift)
├── GameViewController.swift  # Game board
├── StatisticsViewController.swift  # Statistics display
├── SettingsViewController.swift    # Settings and about
├── Base.lproj/
│   ├── Main.storyboard      # UI layouts
│   └── LaunchScreen.storyboard
├── Assets.xcassets/         # App icons and images
└── Info.plist
```

## Future Enhancements

- [ ] Online multiplayer support
- [ ] Remote AI API integration
- [ ] Game replay functionality
- [ ] Custom themes and animations
- [ ] Achievement system
- [ ] Game history tracking

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Rohan Poudel**

- GitHub: [@rohanpoudel](https://github.com/rohanpoudel)

## Acknowledgments

- Built as part of CodePath iOS development course
- Minimax algorithm implementation inspired by classic game theory
- UI design follows Apple Human Interface Guidelines
