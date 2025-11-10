# ☕ Espresso Tracker

A comprehensive iOS application for tracking and perfecting your espresso brewing journey. Built with SwiftUI and Core Data, featuring iCloud sync, dark mode UI, and detailed brewing analytics.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

## Features

### 🎯 Core Features

- **Equipment Management**
  - Track your grinders with burr specifications
  - Manage espresso machines with technical details
  - Store images and notes for each piece of equipment
  - View usage statistics

- **Coffee Bean Tracking**
  - Log roast dates and track freshness
  - Store origin, process, and variety information
  - Add tasting notes and flavor profiles
  - Automatic freshness indicators (Very Fresh → Stale)
  - Price and weight tracking

- **Brewing Session Tracker**
  - Real-time stopwatch with millisecond precision
  - Brew ratio calculator (Ristretto, Normale, Lungo, Custom)
  - Equipment and bean selection
  - Customizable parameters (grind setting, water temp, pressure)
  - Extraction quality indicators
  - Shot photography
  - Rating system (1-5 stars)

- **Comprehensive History**
  - Chronological session log
  - Statistics dashboard:
    - Total shots brewed
    - Average brew time
    - Average ratio
    - Weekly activity
  - Detailed session view with all parameters
  - Extraction analysis

### 🎨 Design

- **Modern Dark Mode UI**
  - Espresso-inspired color palette
  - Custom components and cards
  - Smooth animations
  - Professional typography

- **User Experience**
  - Intuitive tab-based navigation
  - Empty states with helpful guidance
  - Confirmation dialogs for destructive actions
  - Form validation

### ☁️ Data & Sync

- **Local Storage**: Core Data with SQLite
- **iCloud Sync**: Automatic synchronization across devices
- **Image Support**: Store photos of equipment, beans, and shots
- **Data Persistence**: Reliable local storage with cloud backup

## Screenshots

*(Add your app screenshots here once the app is running)*

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- iCloud account (for sync features)

## Installation

### Option 1: Xcode Project

1. Clone the repository:
```bash
git clone https://github.com/yourusername/espresso-tracker.git
cd espresso-tracker
```

2. Open the project in Xcode:
```bash
open EspressoTracker.xcodeproj
```

3. Configure signing:
   - Select the project in Xcode
   - Choose your development team
   - Update the bundle identifier if needed

4. Enable iCloud:
   - Go to Signing & Capabilities
   - Add iCloud capability
   - Check "CloudKit"
   - Ensure the container is configured

5. Build and run:
   - Select your target device or simulator
   - Press Cmd+R to build and run

### Option 2: Swift Package Manager

*(If you structure it as a package in the future)*

## Project Structure

```
EspressoTracker/
├── EspressoTrackerApp.swift      # App entry point
├── ContentView.swift              # Main navigation
├── Core/
│   └── Persistence.swift          # Core Data + iCloud setup
├── Models/                        # Core Data entities
├── ViewModels/                    # Business logic
├── Views/                         # UI layer
│   ├── Brewing/                   # Brewing interface
│   ├── Equipment/                 # Equipment management
│   ├── Beans/                     # Bean tracking
│   └── History/                   # Session history
├── Components/                    # Reusable UI components
└── Theme/                         # Colors and styling
```

For detailed architecture information, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Usage Guide

### First Time Setup

1. **Add Your Equipment**
   - Navigate to Equipment tab
   - Add your grinder(s) with specifications
   - Add your espresso machine(s)
   - Optionally add photos

2. **Add Coffee Beans**
   - Go to Beans tab
   - Add bean details (name, roaster, origin)
   - Set roast date for freshness tracking
   - Add tasting notes

3. **Start Brewing**
   - Go to Brew tab
   - Select equipment and beans
   - Set grind setting and parameters
   - Choose brew ratio
   - Enter dose in (grams)

### Brewing a Shot

1. **Prepare**: Select all equipment and set parameters
2. **Start**: Tap "Start" when you begin extraction
3. **Monitor**: Watch the extraction timer and quality indicator
4. **Stop**: Tap "Stop" when shot is complete
5. **Finish**: Enter actual yield out and rating
6. **Save**: Add notes and save to history

### Viewing History

- Browse all past shots in History tab
- View statistics at the top
- Tap any session for detailed view
- See extraction analysis and quality assessment

## Best Practices

### For Best Results

1. **Consistent Data Entry**: Always fill in grind settings and parameters
2. **Regular Updates**: Keep bean freshness updated
3. **Photo Documentation**: Take photos of exceptional shots
4. **Detailed Notes**: Add tasting notes for memorable shots
5. **Equipment Tracking**: Log when you change equipment or settings

### Brewing Tips Integrated

- **Optimal Extraction**: 25-30 seconds for most beans
- **Standard Ratio**: 1:2 (18g in, 36g out)
- **Ristretto**: 1:1.5 for concentrated flavor
- **Lungo**: 1:2.5 for longer extractions
- **Water Temp**: 90-96°C depending on roast level
- **Pressure**: 9 bars is standard

## Technologies Used

- **SwiftUI**: Declarative UI framework
- **Core Data**: Local persistence
- **CloudKit**: iCloud synchronization
- **Combine**: Reactive programming
- **PhotosUI**: Image picking
- **Timer**: Stopwatch functionality

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

- **Models**: Core Data entities (Grinder, Machine, Bean, BrewingSession)
- **ViewModels**: Business logic (DataManager, BrewingViewModel)
- **Views**: SwiftUI views organized by feature
- **Components**: Reusable UI elements

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed documentation.

## Data Model

### Core Entities

- **Grinder**: Brand, model, burr type/size, specifications
- **Machine**: Brand, model, boiler type, group head, pressure
- **Bean**: Name, roaster, origin, roast date, process, variety, tasting notes
- **BrewingSession**: Parameters, timing, equipment used, rating, notes

### Relationships

- One Grinder → Many Sessions
- One Machine → Many Sessions
- One Bean → Many Sessions

## iCloud Sync

The app automatically syncs data across your devices using CloudKit:

- Seamless multi-device support
- Automatic conflict resolution
- Background sync
- Works when online

**Setup**: Just sign in with your Apple ID and enable iCloud for the app.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Enhancements

- [ ] Export data (CSV, PDF reports)
- [ ] Advanced analytics and charts
- [ ] Shot comparison feature
- [ ] Recipe templates
- [ ] Maintenance scheduling
- [ ] Water chemistry tracking
- [ ] Pressure profiling
- [ ] Apple Watch companion app
- [ ] Widget support
- [ ] Shortcuts integration

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the specialty coffee community
- Built with love for espresso enthusiasts
- Icons from SF Symbols

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Email: support@espressotracker.app
- Twitter: @EspressoTracker

## Author

Created with ☕ by [Your Name]

---

**Happy Brewing!** ☕✨
