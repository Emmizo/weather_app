import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';
import '../forecast/forecast_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import 'package:weatherapp/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() async {
    final searchProvider = context.read<SearchProvider>();
    final forecastProvider = context.read<ForecastProvider>();
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    await searchProvider.searchCity(city);
    if (searchProvider.location != null) {
      await forecastProvider.fetchForecast(searchProvider.location!);
      if (mounted) {
        Navigator.of(context).pop(); // Close modal on success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    if (provider.location != null &&
        _controller.text != provider.location!.name) {
      _controller.text = provider.location!.name;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.searchCityTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: l10n.close,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: l10n.enterCityName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _onSearch(),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onSearch,
                      icon: const Icon(Icons.search),
                      label: Text(l10n.search),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (provider.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LoadingIndicator(),
                    ),
                  if (provider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AppErrorWidget(message: provider.error!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
