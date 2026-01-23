import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../models/site.dart';
import '../data/repositories/sites_repository.dart';

enum SitesState { initial, loading, loaded, error }

class SitesProvider with ChangeNotifier {
  @visibleForTesting
  SitesState _state = SitesState.initial;
  @visibleForTesting
  List<Site> _sites = [];
  @visibleForTesting
  List<Site> _featuredSites = [];
  Site? _selectedSite;
  String? _errorMessage;

  // Getters
  SitesState get state => _state;
  List<Site> get sites => _sites;
  List<Site> get featuredSites => _featuredSites;
  Site? get selectedSite => _selectedSite;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SitesState.loading;
  bool get hasError => _state == SitesState.error;

  /// Charger tous les sites
  Future<void> loadSites() async {
    _setState(SitesState.loading);

    final response = await SitesRepository.getAllSites();

    if (response.success && response.data != null) {
      _sites = response.data!;
      _setState(SitesState.loaded);
    } else {
      _setState(SitesState.error, error: response.message);
    }
  }

  /// Charger les sites phares
  Future<void> loadFeaturedSites() async {
    final response = await SitesRepository.getFeaturedSites();

    if (response.success && response.data != null) {
      _featuredSites = response.data!;
      notifyListeners();
    }
  }

  /// Charger un site par ID
  Future<void> loadSiteById(String id) async {
    _setState(SitesState.loading);

    final response = await SitesRepository.getSiteById(id);

    if (response.success && response.data != null) {
      _selectedSite = response.data;
      _setState(SitesState.loaded);
    } else {
      _setState(SitesState.error, error: response.message);
    }
  }

  /// Sélectionner un site
  void selectSite(Site site) {
    _selectedSite = site;
    notifyListeners();
  }

  /// Filtrer les sites par catégorie
  List<Site> filterByCategory(String category) {
    return _sites
        .where((site) => site.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Rechercher des sites
  List<Site> searchSites(String query) {
    if (query.isEmpty) return _sites;

    return _sites.where((site) {
      return site.name.toLowerCase().contains(query.toLowerCase()) ||
          site.description.toLowerCase().contains(query.toLowerCase()) ||
          site.category.toLowerCase().contains(query.toLowerCase()) ||
          site.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Changer l'état
  void _setState(SitesState newState, {String? error}) {
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  /// Méthode pour changer l'état en test
  @visibleForTesting
  void setStateForTesting(SitesState newState, {String? error}) {
    _setState(newState, error: error);
  }

  /// Réinitialiser l'erreur
  void clearError() {
    _errorMessage = null;
    if (_state == SitesState.error) {
      _setState(SitesState.initial);
    }
  }

  /// Méthode pour définir les sites en test
  @visibleForTesting
  void setSitesForTesting(List<Site> sites) {
    _sites = sites;
  }

  /// Rafraîchir les données
  Future<void> refresh() async {
    await loadSites();
    await loadFeaturedSites();
  }
}
