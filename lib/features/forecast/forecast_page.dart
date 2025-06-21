import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/l10n/app_localizations.dart';
import 'forecast_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import '../../core/utils/weather_code_mapper.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../search/search_provider.dart';
import '../search/search_page.dart';
import '../../core/utils/theme_provider.dart';
import 'widgets/hourly_forecast.dart';
import 'widgets/daily_forecast.dart';
import '../../core/utils/unit_provider.dart';
import '../../core/utils/locations_provider.dart';
import 'widgets/astro_card.dart';
import 'widgets/air_quality_card.dart';
import 'widgets/weather_suggestion_banner.dart';
import 'widgets/farming_prediction_card.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../core/api/api_keys.dart';

enum MapLayerType { none, wind, temp, rain }

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage>
    with SingleTickerProviderStateMixin {
  MapLayerType _selectedLayer = MapLayerType.wind;
  late final AnimationController _windController;

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _windController.dispose();
    super.dispose();
  }

  void _showLocationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final locationsProvider = Provider.of<LocationsProvider>(ctx);
        final searchProvider = Provider.of<SearchProvider>(ctx, listen: false);
        final l10n = AppLocalizations.of(ctx)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.savedLocations,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ...locationsProvider.locations.map(
                (loc) => ListTile(
                  title: Text(loc.name),
                  subtitle: Text(
                    '(${loc.latitude.toStringAsFixed(2)}, ${loc.longitude.toStringAsFixed(2)})',
                  ),
                  trailing:
                      locationsProvider.selected?.latitude == loc.latitude &&
                          locationsProvider.selected?.longitude == loc.longitude
                      ? const Icon(Icons.check, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await locationsProvider.removeLocation(loc);
                          },
                        ),
                  onTap: () async {
                    final prov = Provider.of<ForecastProvider>(
                      ctx,
                      listen: false,
                    );
                    final searchProv = Provider.of<SearchProvider>(
                      ctx,
                      listen: false,
                    );

                    await locationsProvider.selectLocation(loc);
                    searchProv.setLocation(loc);
                    await prov.fetchForecast(loc);

                    if (mounted) {
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_location_alt),
                title: Text(l10n.addCurrentLocation),
                onTap: () async {
                  final loc = searchProvider.location;
                  if (loc != null) {
                    await locationsProvider.addLocation(loc);
                  }
                  if (mounted) {
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = context.watch<SearchProvider>().location;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final unitProvider = Provider.of<UnitProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(location?.name ?? l10n.currentLocation),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _showLocationsSheet(context),
            tooltip: l10n.manageLocations,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const SearchPage(),
                ),
              );
            },
            tooltip: l10n.search,
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggleTheme,
            tooltip: themeProvider.isDarkMode ? l10n.lightMode : l10n.darkMode,
          ),
          IconButton(
            icon: Icon(
              unitProvider.unit == TempUnit.celsius
                  ? Icons.thermostat
                  : Icons.device_thermostat,
            ),
            onPressed: unitProvider.toggleUnit,
            tooltip: unitProvider.unit == TempUnit.celsius
                ? l10n.showFahrenheit
                : l10n.showCelsius,
          ),
        ],
      ),
      body: Consumer<ForecastProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const LoadingIndicator();
          }
          if (provider.error != null) {
            return AppErrorWidget(message: provider.error!);
          }
          final forecasts = provider.dailyForecasts;
          if (forecasts == null || forecasts.isEmpty) {
            return Center(child: Text(l10n.noForecastData));
          }
          final current = forecasts[provider.selectedDay];
          final hour = DateTime.now().hour;
          final bgAsset = WeatherCodeMapper.background(
            current.weatherCode,
            hour,
          );
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  bgAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[300]),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        WeatherSuggestionBanner(
                          weather: current,
                          airQuality: provider.hourlyAirQuality,
                          outlookAnalysis: provider.outlookAnalysis,
                        ),
                        FarmingPredictionCard(
                          analysis: provider.outlookAnalysis,
                        ),
                        if (location != null &&
                            location.latitude != 0.0 &&
                            location.longitude != 0.0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    options: MapOptions(
                                      initialCenter: LatLng(
                                        location.latitude,
                                        location.longitude,
                                      ),
                                      initialZoom: 10,
                                      interactionOptions:
                                          const InteractionOptions(
                                            flags:
                                                InteractiveFlag.pinchZoom |
                                                InteractiveFlag.drag,
                                          ),
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      ),
                                      if (_selectedLayer != MapLayerType.none)
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openweathermap.org/map/${_selectedLayer.name}/{z}/{x}/{y}.png?appid=$openWeatherApiKey',
                                          backgroundColor: Colors.transparent,
                                        ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 80.0,
                                            height: 80.0,
                                            point: LatLng(
                                              location.latitude,
                                              location.longitude,
                                            ),
                                            child: const Icon(
                                              Icons.location_pin,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_selectedLayer == MapLayerType.wind)
                                        AnimatedBuilder(
                                          animation: _windController,
                                          builder: (context, child) {
                                            return CustomPaint(
                                              painter: WindOverlayPainter(
                                                _windController.value,
                                              ),
                                              size: Size.infinite,
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Column(
                                      children: [
                                        _buildLayerChip(
                                          context,
                                          MapLayerType.wind,
                                          l10n.windLayer,
                                          Icons.air,
                                        ),
                                        _buildLayerChip(
                                          context,
                                          MapLayerType.temp,
                                          l10n.tempLayer,
                                          Icons.thermostat,
                                        ),
                                        _buildLayerChip(
                                          context,
                                          MapLayerType.rain,
                                          l10n.rainLayer,
                                          Icons.water_drop,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        _SectionHeader(title: l10n.hourlyForecast),
                        SizedBox(
                          height: 180,
                          child: HourlyForecast(
                            forecasts: provider.hourlyForecasts ?? [],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionHeader(title: l10n.dailyForecast),
                        DailyForecast(forecasts: forecasts),
                        const SizedBox(height: 16),
                        _SectionHeader(title: l10n.astroAirQuality),
                        if (provider.hourlyAirQuality != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: AstroCard(day: current)),
                              Expanded(
                                child: AirQualityCard(
                                  airQuality: provider.hourlyAirQuality!,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLayerChip(
    BuildContext context,
    MapLayerType layer,
    String label,
    IconData icon,
  ) {
    final bool isSelected = _selectedLayer == layer;
    final Color backgroundColor = isSelected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
        : Colors.black.withOpacity(0.5);
    final Color foregroundColor = isSelected
        ? Colors.white
        : Colors.white.withOpacity(0.8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () => setState(() => _selectedLayer = layer),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WindOverlayPainter extends CustomPainter {
  final double animationValue;

  WindOverlayPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = ui.Path();
    const waveHeight = 15.0;
    const waveLength = 80.0;
    final sinOffset = math.sin(animationValue * 2 * math.pi);

    for (double y = -waveHeight; y < size.height + waveHeight; y += 30) {
      path.moveTo(-waveLength, y + sinOffset * 5);
      for (
        double x = -waveLength;
        x < size.width + waveLength;
        x += waveLength
      ) {
        final controlX1 = x + waveLength / 4;
        final controlY1 = y - waveHeight;
        final controlX2 = x + (waveLength / 4 * 3);
        final controlY2 = y + waveHeight;
        final endX = x + waveLength;
        final endY = y + math.sin(animationValue * 2 * math.pi + x / 50) * 5;
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, endX, endY);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WindOverlayPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
