import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'features/search/search_provider.dart';
import 'features/forecast/forecast_provider.dart';
import 'features/search/search_page.dart';
import 'features/forecast/forecast_page.dart';
import 'package:geolocator/geolocator.dart';
import 'core/models/location.dart';
import 'core/utils/theme_provider.dart';
import 'core/utils/unit_provider.dart';
import 'core/utils/locations_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weatherapp/l10n/material_localizations_rw.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Weather App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Builder(
              builder: (context) => HomePage(
                setLocale: setLocale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                  Locale('rw'),
                ],
              ),
            ),
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: const [
              MaterialLocalizationsRw.delegate,
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('fr'), Locale('rw')],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null && locale.languageCode == 'rw') {
                // Use your own translations for rw, but fallback to en for Material/Cupertino
                return const Locale('rw');
              }
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final void Function(Locale)? setLocale;
  final List<Locale> supportedLocales;
  const HomePage({super.key, this.setLocale, required this.supportedLocales});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  bool _locationError = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchDefaultForecast();
    }
    _isInit = false;
  }

  Future<void> _fetchDefaultForecast() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever.');
      }
      final position = await Geolocator.getCurrentPosition();
      final location = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        name: l10n.currentLocation,
      );
      if (!mounted) return;
      final searchProvider = context.read<SearchProvider>();
      final forecastProvider = context.read<ForecastProvider>();
      searchProvider.setLocation(location);
      await forecastProvider.fetchForecast(location);
      setState(() {
        _loading = false;
        _locationError = false;
      });
    } catch (e) {
      // Try to use last known position
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          final location = Location(
            latitude: lastPosition.latitude,
            longitude: lastPosition.longitude,
            name: l10n.lastKnownLocation,
          );
          if (!mounted) return;
          final searchProvider = context.read<SearchProvider>();
          final forecastProvider = context.read<ForecastProvider>();
          searchProvider.setLocation(location);
          await forecastProvider.fetchForecast(location);
          setState(() {
            _loading = false;
            _locationError = false;
          });
          return;
        }
      } catch (_) {}
      // Fallback to default city (Kigali)
      final defaultLocation = Location(
        latitude: -1.9577,
        longitude: 30.1127,
        name: 'Kigali',
      );
      if (!mounted) return;
      final searchProvider = context.read<SearchProvider>();
      final forecastProvider = context.read<ForecastProvider>();
      searchProvider.setLocation(defaultLocation);
      await forecastProvider.fetchForecast(defaultLocation);
      setState(() {
        _loading = false;
        _locationError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_locationError) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)?.locationPermissionDenied ??
                      'Location permission denied or unavailable. Please search for a city.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _fetchDefaultForecast,
                  child: Text(
                    AppLocalizations.of(context)?.retryLocation ??
                        'Retry Location',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  child: Text(
                    AppLocalizations.of(context)?.openAppSettings ??
                        'Open App Settings',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)?.searchCity ?? 'Search City',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.forecast ?? 'Forecast'),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              widget.setLocale?.call(locale);
            },
            itemBuilder: (context) => widget.supportedLocales.map((locale) {
              String langName;
              switch (locale.languageCode) {
                case 'en':
                  langName = AppLocalizations.of(context)?.english ?? 'English';
                  break;
                case 'fr':
                  langName = AppLocalizations.of(context)?.french ?? 'Français';
                  break;
                case 'rw':
                  langName =
                      AppLocalizations.of(context)?.kinyarwanda ??
                      'Kinyarwanda';
                  break;
                default:
                  langName = locale.languageCode;
              }
              return PopupMenuItem(value: locale, child: Text(langName));
            }).toList(),
          ),
        ],
      ),
      body: const ForecastPage(),
    );
  }
}
