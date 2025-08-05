# Original App Design Project - README Template

# TicTacAI

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

TicTacAI is a modern iOS tic-tac-toe game that combines classic gameplay with cutting-edge AI technology. Players can enjoy local two-player matches or challenge themselves against three different AI opponents: Easy (random moves), Hard (unbeatable Minimax algorithm), and Online (OpenAI GPT-3.5-turbo integration). The app features comprehensive statistics tracking, customizable settings, and a clean UIKit interface designed for quick, engaging gameplay sessions.

### App Evaluation

[Evaluation of your app across the following attributes]

- **Category:** Games / AI / Entertainment
- **Mobile:** Mobile-first design with touch-optimized individual button controls, perfect for quick gaming sessions. Leverages networking for OpenAI integration and local storage for statistics persistence.
- **Story:** Demonstrates the evolution of AI in gaming, from simple random moves to sophisticated language model strategies. Appeals to both casual gamers and those interested in AI technology.
- **Market:** Broad appeal to puzzle game enthusiasts, students learning about AI algorithms, mobile gamers, and developers interested in AI integration patterns. Universal game recognition makes it accessible to all age groups.
- **Habit:** High replayability with four distinct difficulty modes encouraging repeated play. Quick 30-second to 2-minute sessions perfect for breaks, commutes, or casual entertainment.
- **Scope:** Successfully scaled from basic game implementation to comprehensive app with multiple AI modes, statistics tracking, and settings management. Well-defined scope with clear technical milestones.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- User can play a classic tic-tac-toe game in two-player mode
- User can select between different game modes (Two Player, Single Player Easy, Single Player Hard, Single Player Online)
- User can see the current game state with clear X and O markers
- User can see who wins or if it's a draw after each game
- User can navigate between the home screen and game screen
- User can view comprehensive statistics of their gameplay
- User can access settings to customize their experience



**Future Features (Not Yet Implemented)**

- Sound effects and animations (UI framework ready for implementation)
- Haptic feedback for moves
- Custom themes and visual effects
- Advanced AI personality modes

### 2. Screen Archetypes

- [x] **Home Screen (ViewController)**

  - User can select between Two Player and Single Player modes
  - User can choose AI difficulty (Easy, Hard, Online) for Single Player mode
  - User can navigate to Statistics and Settings screens

- [x] **Game Screen (GameViewController)**

  - User can tap on grid positions to make moves
  - User can see current player turn and game state
  - User can see win/draw results with option to play again or return home

- [x] **Statistics Screen (StatisticsViewController)**

  - User can view comprehensive game statistics
  - User can see win/loss records for different game modes
  - User can view total games played and draw counts

- [x] **Settings Screen (SettingsViewController)**
  - User can toggle various app preferences (UI ready, core features implemented)
  - User can reset statistics
  - User can view app information
  - User can manage API key configuration for online AI mode

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- No tab navigation - app uses modal/push navigation pattern

**Flow Navigation** (Screen to Screen)

- [x] **Home Screen**

  - Navigate to Game Screen (with selected mode)
  - Navigate to Statistics Screen
  - Navigate to Settings Screen

- [x] **Game Screen**

  - Navigate back to Home Screen
  - Navigate to Play Again (restart current mode)

- [x] **Statistics Screen**

  - Navigate back to Home Screen

- [x] **Settings Screen**
  - Navigate back to Home Screen

## Wireframes

<!-- TODO: Add hand sketched wireframes here -->

<img src="https://github.com/poudelrohan/TicTacAI/blob/16e10f3de76d2a3c0398fdade2f30f86c37f2481/IMG_0685.jpg" width=600>

<!-- Note: Need to hand draw the following screens:
1. Home Screen with mode selection buttons
2. Game Screen with 3x3 grid and game state
3. Statistics Screen with win/loss data
4. Settings Screen with toggle options -->

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema

### Models

| Model             | Properties                                                                        | Description                                   |
| ----------------- | --------------------------------------------------------------------------------- | --------------------------------------------- |
| GameModel         | board: [Player?], currentPlayer: Player, gameMode: GameMode, gameState: GameState | Core game logic and state management          |
| Player            | X, O (enum)                                                                       | Represents game pieces with opposite property |
| GameMode          | twoPlayer, singlePlayerEasy, singlePlayerHard, singlePlayerOnline (enum)          | Different gameplay modes                      |
| GameState         | ongoing, won(Player), draw (enum)                                                 | Current state of the game                     |
| StatisticsManager | playerXName, playerOName, various win/loss counters                               | Persistent statistics using UserDefaults      |

### Networking

**OpenAI Integration (Online AI Mode)**

- [GET] OpenAI API Chat Completions
  ```
  Base URL: https://api.openai.com/v1/chat/completions
  Method: POST
  Headers: Authorization: Bearer {API_KEY}
  Body: JSON with game board state and strategic prompt
  ```

**Network Requests by Screen:**

- **Game Screen (Online AI Mode)**
  - Send current board state to OpenAI API
  - Receive strategic move recommendation
  - Parse and validate AI move response

**API Endpoints:**

- OpenAI GPT-3.5-turbo Chat Completions API
- Custom prompt engineering for tic-tac-toe strategy
- Enhanced board representation and move validation

**Current Implementation Notes:**

- ✅ Core game functionality fully implemented and tested
- ✅ All four AI modes working (Two Player, Easy, Hard, Online)
- ✅ Statistics tracking and settings UI implemented
- ✅ Secure API key management through Config.swift
- ⚠️ OpenAI responses occasionally need validation (working on prompt optimization)
- ⚠️ Settings toggles (sound/animations) have UI but functionality pending
- 🔄 Minor UI improvements and AI fine-tuning in progress

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

## Author

**Rohan Poudel**

- GitHub: [@rohanpoudel](https://github.com/rohanpoudel)

## Acknowledgments

- Built as part of CodePath iOS development course
- Minimax algorithm implementation inspired by classic game theory
- UI design follows Apple Human Interface Guidelines
