import 'package:flutter/material.dart';
import '../../../core/models/forecast_outlook.dart';
import '../../../l10n/app_localizations.dart';
import 'farming_prediction_card.dart';

class FarmingPredictionScreen extends StatelessWidget {
  final OutlookAnalysis? analysis;

  const FarmingPredictionScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.farmingPredictionCardTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FarmingPredictionCard(analysis: analysis),
          ),
        ),
      ),
    );
  }
}
