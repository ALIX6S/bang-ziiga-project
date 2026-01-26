import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/colors.dart';
import '../../core/widgets/app_bar_custom.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../providers/itineraires_provider.dart';
import 'widgets/itineraire_card.dart';
import 'itineraire_detail_screen.dart';

class ItinerairesListScreen extends StatefulWidget {
  const ItinerairesListScreen({super.key});

  @override
  State<ItinerairesListScreen> createState() => _ItinerairesListScreenState();
}

class _ItinerairesListScreenState extends State<ItinerairesListScreen> {
  @override
  void initState() {
    super.initState();
    _loadItineraires();
  }

  Future<void> _loadItineraires() async {
    final provider = Provider.of<ItinerairesProvider>(context, listen: false);
    await provider.loadItineraires();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarCustom(
        title: 'Itinéraires',
      ),
      body: Consumer<ItinerairesProvider>(
        builder: (context, provider, child) {
          // État de chargement
          if (provider.isLoading) {
            return const LoadingWidget(
              message: 'Chargement des itinéraires...',
            );
          }

          // État d'erreur
          if (provider.hasError) {
            return ErrorDisplayWidget(
              message: provider.errorMessage ?? 'Une erreur est survenue',
              onRetry: _loadItineraires,
            );
          }

          // État vide
          if (provider.itineraires.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.route_outlined,
              title: 'Aucun itinéraire disponible',
              message: 'Revenez plus tard pour découvrir de nouveaux parcours',
            );
          }

          return RefreshIndicator(
            onRefresh: _loadItineraires,
            color: AppColors.evergreen,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.itineraires.length,
              itemBuilder: (context, index) {
                final itineraire = provider.itineraires[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ItineraireCard(
                    itineraire: itineraire,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ItineraireDetailScreen(itineraire: itineraire),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}