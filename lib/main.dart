import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'features/search/search_provider.dart';
import 'features/forecast/forecast_provider.dart';
import 'features/forecast/forecast_page.dart';
import 'core/utils/theme_provider.dart';
import 'core/utils/unit_provider.dart';
import 'core/utils/locations_provider.dart';
import 'core/utils/language_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weatherapp/l10n/material_localizations_rw.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          return MaterialApp(
            title: 'Weather App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forecast),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              languageProvider.setLanguage(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.english),
              ),
              PopupMenuItem(
                value: const Locale('fr'),
                child: Text(l10n.french),
              ),
              PopupMenuItem(
                value: const Locale('rw'),
                child: Text(l10n.kinyarwanda),
              ),
            ],
          ),
        ],
      ),
      body: const ForecastPage(),
    );
  }
}
