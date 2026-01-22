import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/colors.dart';
import '../../core/widgets/app_bar_custom.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/search_bar_custom.dart';
import '../../providers/sites_provider.dart';
import 'widgets/site_card.dart';
import 'site_detail_screen.dart';

class SitesListScreen extends StatefulWidget {
  const SitesListScreen({Key? key}) : super(key: key);

  @override
  State<SitesListScreen> createState() => _SitesListScreenState();
}

class _SitesListScreenState extends State<SitesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    final sitesProvider = Provider.of<SitesProvider>(context, listen: false);
    await sitesProvider.loadSites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarCustom(
        title: 'Sites Touristiques',
      ),
      body: Consumer<SitesProvider>(
        builder: (context, sitesProvider, child) {
          // État de chargement
          if (sitesProvider.isLoading) {
            return const LoadingWidget(
              message: 'Chargement des sites...',
            );
          }

          // État d'erreur
          if (sitesProvider.hasError) {
            return ErrorDisplayWidget(
              message: sitesProvider.errorMessage ?? 'Une erreur est survenue',
              onRetry: _loadSites,
            );
          }

          // État vide
          if (sitesProvider.sites.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.explore_off,
              title: 'Aucun site disponible',
              message: 'Revenez plus tard pour découvrir de nouveaux sites',
            );
          }

          // Filtrer les sites selon la recherche
          final filteredSites = _searchQuery.isEmpty
              ? sitesProvider.sites
              : sitesProvider.searchSites(_searchQuery);

          return Column(
            children: [
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarCustom(
                  hint: 'Rechercher un site...',
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onClear: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),

              // Nombre de résultats
              if (_searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredSites.length} résultat(s) trouvé(s)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Liste des sites
              Expanded(
                child: filteredSites.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.search_off,
                        title: 'Aucun résultat',
                        message: 'Essayez avec d\'autres mots-clés',
                      )
                    : RefreshIndicator(
                        onRefresh: _loadSites,
                        color: AppColors.evergreen,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredSites.length,
                          itemBuilder: (context, index) {
                            final site = filteredSites[index];
                            return SiteCard(
                              site: site,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SiteDetailScreen(site: site),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}