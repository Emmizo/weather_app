# Weather App

A comprehensive weather forecast application built with Flutter that provides detailed weather information, forecasts, and AI-powered insights.

## Features

### Core Weather Features
- **Current Weather**: Real-time weather conditions with temperature, wind, humidity, and weather codes
- **Hourly Forecast**: 24-hour detailed weather predictions
- **Daily Forecast**: 7-day weather outlook
- **Interactive Map**: Weather layers including wind, temperature, and rain with OpenStreetMap integration
- **Air Quality**: Real-time air quality index and particulate matter data
- **Astronomical Data**: Sunrise, sunset times and moon phases

### AI-Powered Features
- **AI Weather Insights**: Personalized weather summaries and analysis powered by OpenAI GPT-3.5
- **Activity Recommendations**: AI-suggested outdoor and indoor activities based on weather conditions
- **Clothing Recommendations**: Smart clothing suggestions for current weather conditions
- **Weather Alerts**: Intelligent weather warnings and safety tips

### Additional Features
- **Multi-language Support**: English, French, and Kinyarwanda
- **Location Management**: Save and manage multiple locations
- **Theme Support**: Light and dark mode
- **Unit Conversion**: Celsius and Fahrenheit temperature units
- **Farming Predictions**: 16-day agricultural weather outlook
- **Weather Suggestions**: Contextual weather advice and alerts

## Setup

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd weatherapp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API Keys:
   - Open `lib/core/api/api_keys.dart`
   - Add your OpenWeather API key
   - Add your OpenAI API key

4. Run the app:
```bash
flutter run
```

### API Keys Required

#### OpenWeather API
- Get your API key from [OpenWeather](https://openweathermap.org/api)
- Add it to `lib/core/api/api_keys.dart`

#### OpenAI API
- Get your API key from [OpenAI](https://platform.openai.com/api-keys)
- Add it to `lib/core/api/api_keys.dart`

## Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── core/
│   ├── api/           # API clients and services
│   ├── models/        # Data models
│   └── utils/         # Utility classes and providers
├── features/
│   ├── forecast/      # Weather forecast feature
│   └── search/        # Location search feature
├── l10n/              # Localization files
├── theme/             # App theming
└── widgets/           # Shared widgets
```

## AI Integration

The app integrates OpenAI's GPT-3.5 model to provide intelligent weather insights:

### Features
- **Weather Summary**: AI-generated weather summaries for the current day
- **Activity Suggestions**: AI-suggested outdoor and indoor activities based on weather conditions
- **Clothing Advice**: Smart clothing suggestions considering temperature and weather patterns
- **Multilingual Support**: AI responses are generated in the user's selected language (English, French, Kinyarwanda)

### Implementation
- Uses OpenAI's Chat Completions API
- Processes weather data to create contextual prompts
- Automatically detects user's language preference and generates responses accordingly
- Provides fallback responses when AI services are unavailable
- Optimized for performance with caching and error handling

### Language Support
The AI integration supports all three app languages:
- **English**: Default language for AI responses
- **French**: AI responds in French (Français)
- **Kinyarwanda**: AI responds in Kinyarwanda (Ikinyarwanda)

The language is automatically detected from the user's app settings and passed to the AI service to ensure responses are in the appropriate language.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Weather data provided by Open-Meteo API
- Map tiles from OpenStreetMap
- AI insights powered by OpenAI
- Icons from Material Design
