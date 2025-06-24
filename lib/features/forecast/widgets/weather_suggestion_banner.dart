import 'package:flutter/material.dart';
import 'package:weatherapp/l10n/app_localizations.dart';
import '../../../core/models/daily_weather.dart';
import '../../../core/models/hourly_air_quality.dart';
import '../../../core/models/forecast_outlook.dart';
import '../../../core/utils/weather_code_mapper.dart';
import 'dart:math' as math;

class WeatherSuggestion {
  final String title;
  final String suggestion;
  final IconData icon;
  final Color color;
  final WeatherAlertType type;

  WeatherSuggestion({
    required this.title,
    required this.suggestion,
    required this.icon,
    required this.color,
    required this.type,
  });
}

enum WeatherAlertType {
  severe, // Thunderstorms, heavy rain
  advisory, // Wind, heat, air quality
  clothing, // General clothing suggestions
  farming, // Farming predictions
}

class WeatherSuggestionBanner extends StatefulWidget {
  final DailyWeather weather;
  final List<HourlyAirQuality>? airQuality;
  final OutlookAnalysis? outlookAnalysis;

  const WeatherSuggestionBanner({
    super.key,
    required this.weather,
    this.airQuality,
    this.outlookAnalysis,
  });

  @override
  State<WeatherSuggestionBanner> createState() =>
      _WeatherSuggestionBannerState();
}

class _WeatherSuggestionBannerState extends State<WeatherSuggestionBanner>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  List<WeatherSuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _generateSuggestions();
      _startAutoSlide();
    });
  }

  @override
  void didUpdateWidget(covariant WeatherSuggestionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weather != oldWidget.weather ||
        widget.airQuality != oldWidget.airQuality ||
        widget.outlookAnalysis != oldWidget.outlookAnalysis) {
      _generateSuggestions();
      _animationController.reset();
      _startAutoSlide();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateSuggestions();
  }

  void _generateSuggestions() {
    if (!mounted || AppLocalizations.of(context) == null) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final temp = widget.weather.tempMax;
    final weatherCode = widget.weather.weatherCode;
    final windSpeed = widget.weather.windSpeed;
    final aqi = widget.airQuality?.first.aqi;
    final outlookAnalysis = widget.outlookAnalysis;

    final newSuggestions = <WeatherSuggestion>[];

    // Priority 1: Severe Weather Warnings
    if (WeatherCodeMapper.isThunderstorm(weatherCode)) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.thunderstormWarningTitle,
          suggestion: l10n.thunderstormWarningBody,
          icon: Icons.flash_on,
          color: Colors.red.shade700,
          type: WeatherAlertType.severe,
        ),
      );
    }
    if (WeatherCodeMapper.isHeavyRain(weatherCode)) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.heavyRainWarningTitle,
          suggestion: l10n.heavyRainWarningBody,
          icon: Icons.flood,
          color: Colors.blue.shade800,
          type: WeatherAlertType.severe,
        ),
      );
    }

    // Priority 2: Advisories
    if (windSpeed != null && windSpeed > 30) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.strongWindAdvisoryTitle,
          suggestion: l10n.strongWindAdvisoryBody,
          icon: Icons.air,
          color: Colors.cyan.shade700,
          type: WeatherAlertType.advisory,
        ),
      );
    }
    if (temp >= 30) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.extremeHeatAlertTitle,
          suggestion: l10n.extremeHeatAlertBody,
          icon: Icons.local_fire_department,
          color: Colors.deepOrange.shade600,
          type: WeatherAlertType.advisory,
        ),
      );
    }
    if (aqi != null && aqi > 100) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.poorAirQualityTitle,
          suggestion: l10n.poorAirQualityBody,
          icon: Icons.masks,
          color: Colors.brown.shade600,
          type: WeatherAlertType.advisory,
        ),
      );
    }

    // Priority 3: Farming Predictions (if available)
    if (outlookAnalysis != null) {
      if (outlookAnalysis.isRainySeason) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.rainySeasonAheadTitle,
            suggestion: l10n.rainySeasonAheadBody,
            icon: Icons.agriculture,
            color: Colors.green.shade700,
            type: WeatherAlertType.farming,
          ),
        );
      }
      if (outlookAnalysis.isDrySeason) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.drySeasonAheadTitle,
            suggestion: l10n.drySeasonAheadBody,
            icon: Icons.water_drop,
            color: Colors.orange.shade700,
            type: WeatherAlertType.farming,
          ),
        );
      }
      if (outlookAnalysis.isHotSeason) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.summerHeatAheadTitle,
            suggestion: l10n.summerHeatAheadBody,
            icon: Icons.wb_sunny,
            color: Colors.red.shade600,
            type: WeatherAlertType.farming,
          ),
        );
      }
      if (outlookAnalysis.isColdSeason) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.coldSeasonAheadTitle,
            suggestion: l10n.coldSeasonAheadBody,
            icon: Icons.ac_unit,
            color: Colors.blue.shade600,
            type: WeatherAlertType.farming,
          ),
        );
      }

      // Additional farming recommendations based on current conditions
      if (temp >= 20 && temp <= 30 && weatherCode == 0) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.plantingSeasonTitle,
            suggestion: l10n.plantingSeasonBody,
            icon: Icons.eco,
            color: Colors.green.shade600,
            type: WeatherAlertType.farming,
          ),
        );
      }

      if (outlookAnalysis.averagePrecipitation < 30) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.irrigationNeededTitle,
            suggestion: l10n.irrigationNeededBody,
            icon: Icons.opacity,
            color: Colors.blue.shade500,
            type: WeatherAlertType.farming,
          ),
        );
      }

      if (temp >= 25 && outlookAnalysis.averagePrecipitation > 50) {
        newSuggestions.add(
          WeatherSuggestion(
            title: l10n.pestControlTitle,
            suggestion: l10n.pestControlBody,
            icon: Icons.bug_report,
            color: Colors.purple.shade600,
            type: WeatherAlertType.farming,
          ),
        );
      }
    }

    // Priority 4: General Clothing Suggestions
    if (temp >= 25) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.hotWeather,
          suggestion: l10n.hotSuggestion,
          icon: Icons.wb_sunny,
          color: Colors.orange,
          type: WeatherAlertType.clothing,
        ),
      );
    } else if (temp <= 10) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.coldWeather,
          suggestion: l10n.coldSuggestion,
          icon: Icons.ac_unit,
          color: Colors.lightBlue,
          type: WeatherAlertType.clothing,
        ),
      );
    }
    if (WeatherCodeMapper.isRainy(weatherCode) &&
        !WeatherCodeMapper.isHeavyRain(weatherCode)) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.rainyWeather,
          suggestion: l10n.rainySuggestion,
          icon: Icons.umbrella,
          color: Colors.indigo,
          type: WeatherAlertType.clothing,
        ),
      );
    } else if (WeatherCodeMapper.isSunny(weatherCode)) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.sunnyWeather,
          suggestion: l10n.sunnySuggestion,
          icon: Icons.wb_sunny,
          color: Colors.amber,
          type: WeatherAlertType.clothing,
        ),
      );
    }

    // Default if nothing else fits
    if (newSuggestions.isEmpty) {
      newSuggestions.add(
        WeatherSuggestion(
          title: l10n.cloudyWeather,
          suggestion: l10n.cloudySuggestion,
          icon: Icons.cloud,
          color: Colors.grey,
          type: WeatherAlertType.clothing,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _suggestions = newSuggestions;
        _currentIndex = 0;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  void _startAutoSlide() {
    if (_suggestions.length <= 1) return;

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextSuggestion();
        _animationController.reset();
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  void _nextSuggestion() {
    if (_suggestions.isEmpty) return;

    setState(() {
      _currentIndex = (_currentIndex + 1) % _suggestions.length;
    });

    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Header with page indicators
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.alertsAndTips,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_suggestions.length > 1) ...[
                  Text(
                    '${_currentIndex + 1}/${_suggestions.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _suggestions.length > 5 ? 5 : _suggestions.length,
                        (index) {
                          // Show first 2, current, and last 2 dots if more than 5
                          if (_suggestions.length > 5) {
                            if (index == 0 ||
                                index == 1 ||
                                index == _currentIndex ||
                                index == _suggestions.length - 2 ||
                                index == _suggestions.length - 1) {
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: _currentIndex == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                              );
                            } else if (index == 2 && _currentIndex > 2) {
                              // Show ellipsis
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Center(
                                  child: Text(
                                    '...',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          } else {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.withValues(alpha: 0.3),
                                border: Border.all(
                                  color: _currentIndex == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Sliding cards container with enhanced visibility
          Container(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return _buildSuggestionCard(_suggestions[index]);
              },
            ),
          ),
          // Swipe indicator
          if (_suggestions.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          math.sin(_animationController.value * 2 * math.pi) *
                              3,
                          0,
                        ),
                        child: Icon(
                          Icons.swipe_left,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.7),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.swipeToSeeMore,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(WeatherSuggestion suggestion) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shadowColor: suggestion.color.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: suggestion.color.withOpacity(0.4),
              width: 2.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                suggestion.color.withOpacity(0.15),
                suggestion.color.withOpacity(0.05),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: suggestion.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: suggestion.color.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    suggestion.icon,
                    color: suggestion.color,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          suggestion.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: suggestion.color,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          suggestion.suggestion,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Priority indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(suggestion.type),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: _getPriorityColor(
                          suggestion.type,
                        ).withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _getPriorityText(suggestion.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(WeatherAlertType type) {
    switch (type) {
      case WeatherAlertType.severe:
        return Colors.red;
      case WeatherAlertType.advisory:
        return Colors.orange;
      case WeatherAlertType.clothing:
        return Colors.blue;
      case WeatherAlertType.farming:
        return Colors.green;
    }
  }

  String _getPriorityText(WeatherAlertType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case WeatherAlertType.severe:
        return l10n.prioritySevere;
      case WeatherAlertType.advisory:
        return l10n.priorityAdvisory;
      case WeatherAlertType.clothing:
        return l10n.priorityTip;
      case WeatherAlertType.farming:
        return l10n.priorityFarming;
    }
  }
}
