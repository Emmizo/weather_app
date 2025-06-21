import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather App'**
  String get appTitle;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @next7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 Days'**
  String get next7Days;

  /// No description provided for @astroAirQuality.
  ///
  /// In en, this message translates to:
  /// **'Astro & Air Quality'**
  String get astroAirQuality;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @aqi.
  ///
  /// In en, this message translates to:
  /// **'AQI'**
  String get aqi;

  /// No description provided for @pm25.
  ///
  /// In en, this message translates to:
  /// **'PM2.5'**
  String get pm25;

  /// No description provided for @pm10.
  ///
  /// In en, this message translates to:
  /// **'PM10'**
  String get pm10;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @overcast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get overcast;

  /// No description provided for @fog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get fog;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @retryLocation.
  ///
  /// In en, this message translates to:
  /// **'Retry Location'**
  String get retryLocation;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open App Settings'**
  String get openAppSettings;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search City'**
  String get searchCity;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @kinyarwanda.
  ///
  /// In en, this message translates to:
  /// **'Kinyarwanda'**
  String get kinyarwanda;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @lastKnownLocation.
  ///
  /// In en, this message translates to:
  /// **'Last Known Location'**
  String get lastKnownLocation;

  /// No description provided for @savedLocations.
  ///
  /// In en, this message translates to:
  /// **'Saved Locations'**
  String get savedLocations;

  /// No description provided for @addCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Current Location'**
  String get addCurrentLocation;

  /// No description provided for @manageLocations.
  ///
  /// In en, this message translates to:
  /// **'Manage Locations'**
  String get manageLocations;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @showFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Show °F'**
  String get showFahrenheit;

  /// No description provided for @showCelsius.
  ///
  /// In en, this message translates to:
  /// **'Show °C'**
  String get showCelsius;

  /// No description provided for @noForecastData.
  ///
  /// In en, this message translates to:
  /// **'No forecast data available.'**
  String get noForecastData;

  /// No description provided for @windLayer.
  ///
  /// In en, this message translates to:
  /// **'WIND'**
  String get windLayer;

  /// No description provided for @tempLayer.
  ///
  /// In en, this message translates to:
  /// **'TEMP'**
  String get tempLayer;

  /// No description provided for @rainLayer.
  ///
  /// In en, this message translates to:
  /// **'RAIN'**
  String get rainLayer;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @dailyForecast.
  ///
  /// In en, this message translates to:
  /// **'Daily Forecast'**
  String get dailyForecast;

  /// No description provided for @dailyWeatherDetails.
  ///
  /// In en, this message translates to:
  /// **'Daily Weather Details'**
  String get dailyWeatherDetails;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uvIndex;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moonPhase;

  /// No description provided for @searchCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Search City'**
  String get searchCityTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get enterCityName;

  /// No description provided for @clothingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Clothing Suggestions'**
  String get clothingSuggestions;

  /// No description provided for @hotWeather.
  ///
  /// In en, this message translates to:
  /// **'Hot Weather Today'**
  String get hotWeather;

  /// No description provided for @coldWeather.
  ///
  /// In en, this message translates to:
  /// **'Cold Weather Today'**
  String get coldWeather;

  /// No description provided for @rainyWeather.
  ///
  /// In en, this message translates to:
  /// **'Rainy Weather Today'**
  String get rainyWeather;

  /// No description provided for @sunnyWeather.
  ///
  /// In en, this message translates to:
  /// **'Sunny Weather Today'**
  String get sunnyWeather;

  /// No description provided for @cloudyWeather.
  ///
  /// In en, this message translates to:
  /// **'Cloudy Weather Today'**
  String get cloudyWeather;

  /// No description provided for @hotSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Today: Wear light clothing, shorts, t-shirts, and sandals. Stay hydrated and seek shade.'**
  String get hotSuggestion;

  /// No description provided for @coldSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Today: Bundle up with a warm jacket, sweater, long pants, and boots. Layer your clothing.'**
  String get coldSuggestion;

  /// No description provided for @rainySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Today: Bring a raincoat, umbrella, and waterproof shoes. Avoid getting soaked.'**
  String get rainySuggestion;

  /// No description provided for @sunnySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Today: Wear sunglasses, hat, light clothing, and apply sunscreen. Protect from UV rays.'**
  String get sunnySuggestion;

  /// No description provided for @cloudySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Today: A light jacket and comfortable clothing should be sufficient. Weather is mild.'**
  String get cloudySuggestion;

  /// No description provided for @alertsAndTips.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Alerts & Tips'**
  String get alertsAndTips;

  /// No description provided for @swipeToSeeMore.
  ///
  /// In en, this message translates to:
  /// **'Swipe to see more • Auto-sliding'**
  String get swipeToSeeMore;

  /// No description provided for @heavyRainWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain Warning Today'**
  String get heavyRainWarningTitle;

  /// No description provided for @heavyRainWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Today: Risk of flash floods. Avoid low-lying areas and riverbanks. Do not drive through flooded roads.'**
  String get heavyRainWarningBody;

  /// No description provided for @thunderstormWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm Warning Today'**
  String get thunderstormWarningTitle;

  /// No description provided for @thunderstormWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Today: Seek shelter indoors immediately. Avoid open fields, tall trees, and water. Unplug electronics.'**
  String get thunderstormWarningBody;

  /// No description provided for @strongWindAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Strong Wind Advisory Today'**
  String get strongWindAdvisoryTitle;

  /// No description provided for @strongWindAdvisoryBody.
  ///
  /// In en, this message translates to:
  /// **'Today: Secure loose objects outdoors. Be cautious of falling branches. Difficult driving conditions expected.'**
  String get strongWindAdvisoryBody;

  /// No description provided for @extremeHeatAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Extreme Heat Alert Today'**
  String get extremeHeatAlertTitle;

  /// No description provided for @extremeHeatAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Today: Stay hydrated and avoid strenuous activity. Seek cool, shaded areas, especially during peak hours.'**
  String get extremeHeatAlertBody;

  /// No description provided for @poorAirQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Poor Air Quality Today'**
  String get poorAirQualityTitle;

  /// No description provided for @poorAirQualityBody.
  ///
  /// In en, this message translates to:
  /// **'Today: Sensitive groups should limit outdoor exertion. Consider wearing a mask if you have respiratory issues.'**
  String get poorAirQualityBody;

  /// No description provided for @farmingPredictions.
  ///
  /// In en, this message translates to:
  /// **'16-Day Farming Outlook'**
  String get farmingPredictions;

  /// No description provided for @rainySeasonAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'Rainy Season Ahead'**
  String get rainySeasonAheadTitle;

  /// No description provided for @rainySeasonAheadBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Prepare for upcoming rainy season. Consider planting rain-fed crops and ensure proper drainage systems.'**
  String get rainySeasonAheadBody;

  /// No description provided for @drySeasonAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'Dry Season Ahead'**
  String get drySeasonAheadTitle;

  /// No description provided for @drySeasonAheadBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Dry weather expected. Plan irrigation systems and consider drought-resistant crops. Store water for livestock.'**
  String get drySeasonAheadBody;

  /// No description provided for @summerHeatAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'Summer Heat Coming'**
  String get summerHeatAheadTitle;

  /// No description provided for @summerHeatAheadBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Hot summer months approaching. Plan for heat-resistant crops and ensure adequate shade for livestock.'**
  String get summerHeatAheadBody;

  /// No description provided for @coldSeasonAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'Cold Season Ahead'**
  String get coldSeasonAheadTitle;

  /// No description provided for @coldSeasonAheadBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Cold weather approaching. Protect sensitive crops and ensure livestock have warm shelter.'**
  String get coldSeasonAheadBody;

  /// No description provided for @plantingSeasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Optimal Planting Time'**
  String get plantingSeasonTitle;

  /// No description provided for @plantingSeasonBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Weather conditions are favorable for planting. Consider starting your crop cycle now.'**
  String get plantingSeasonBody;

  /// No description provided for @harvestingSeasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Harvesting Time'**
  String get harvestingSeasonTitle;

  /// No description provided for @harvestingSeasonBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Optimal conditions for harvesting. Plan your harvest activities during this period.'**
  String get harvestingSeasonBody;

  /// No description provided for @irrigationNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Planning'**
  String get irrigationNeededTitle;

  /// No description provided for @irrigationNeededBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Low rainfall expected. Plan irrigation schedules and water conservation measures.'**
  String get irrigationNeededBody;

  /// No description provided for @pestControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Pest Control Alert'**
  String get pestControlTitle;

  /// No description provided for @pestControlBody.
  ///
  /// In en, this message translates to:
  /// **'Next 16 days: Weather conditions may favor pest development. Monitor crops and plan pest control measures.'**
  String get pestControlBody;

  /// No description provided for @prioritySevere.
  ///
  /// In en, this message translates to:
  /// **'SEVERE'**
  String get prioritySevere;

  /// No description provided for @priorityAdvisory.
  ///
  /// In en, this message translates to:
  /// **'ADVISORY'**
  String get priorityAdvisory;

  /// No description provided for @priorityTip.
  ///
  /// In en, this message translates to:
  /// **'TIP'**
  String get priorityTip;

  /// No description provided for @priorityFarming.
  ///
  /// In en, this message translates to:
  /// **'FARMING'**
  String get priorityFarming;

  /// No description provided for @cityNotFound.
  ///
  /// In en, this message translates to:
  /// **'City not found'**
  String get cityNotFound;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied forever.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @sunriseTime.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseTime;

  /// No description provided for @sunsetTime.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunsetTime;

  /// No description provided for @farmingPredictionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'16-Day Farming Outlook'**
  String get farmingPredictionCardTitle;

  /// No description provided for @avgTemp16Days.
  ///
  /// In en, this message translates to:
  /// **'Avg. Temp (16 days)'**
  String get avgTemp16Days;

  /// No description provided for @avgRainfall16Days.
  ///
  /// In en, this message translates to:
  /// **'Avg. Rainfall Chance (16 days)'**
  String get avgRainfall16Days;

  /// No description provided for @primaryRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Primary Recommendation'**
  String get primaryRecommendation;

  /// No description provided for @defaultRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Plan according to moderate weather conditions.'**
  String get defaultRecommendation;

  /// No description provided for @farmingAnalysisUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Farming analysis data is not available.'**
  String get farmingAnalysisUnavailable;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'rw': return AppLocalizationsRw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
