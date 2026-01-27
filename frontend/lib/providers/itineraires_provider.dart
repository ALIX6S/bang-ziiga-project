import 'package:flutter/material.dart';
import '../models/itineraire.dart';
import '../data/repositories/itineraires_repository.dart';

enum ItinerairesState { initial, loading, loaded, error }

class ItinerairesProvider with ChangeNotifier {
  ItinerairesState _state = ItinerairesState.initial;
  List<Itineraire> _itineraires = [];
  Itineraire? _selectedItineraire;
  String? _errorMessage;

  ItinerairesState get state => _state;
  List<Itineraire> get itineraires => _itineraires;
  Itineraire? get selectedItineraire => _selectedItineraire;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ItinerairesState.loading;
  bool get hasError => _state == ItinerairesState.error;

  Future<void> loadItineraires() async {
    _setState(ItinerairesState.loading);

    final response = await ItinerairesRepository.getAllItineraires();

    if (response.success && response.data != null) {
      _itineraires = response.data!;
      _setState(ItinerairesState.loaded);
    } else {
      _setState(ItinerairesState.error, error: response.message);
    }
  }

  Future<void> loadItineraireById(String id) async {
    _setState(ItinerairesState.loading);

    final response = await ItinerairesRepository.getItineraireById(id);

    if (response.success && response.data != null) {
      _selectedItineraire = response.data;
      _setState(ItinerairesState.loaded);
    } else {
      _setState(ItinerairesState.error, error: response.message);
    }
  }

  void selectItineraire(Itineraire itineraire) {
    _selectedItineraire = itineraire;
    notifyListeners();
  }

  List<Itineraire> filterByDifficulty(String difficulty) {
    return _itineraires
        .where((itineraire) =>
            itineraire.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  Map<String, List<Itineraire>> groupByDifficulty() {
    return {
      'facile': filterByDifficulty('facile'),
      'moyen': filterByDifficulty('moyen'),
      'intense': filterByDifficulty('intense'),
    };
  }

  List<Itineraire> searchItineraires(String query) {
    if (query.isEmpty) return _itineraires;

    return _itineraires.where((itineraire) {
      return itineraire.name.toLowerCase().contains(query.toLowerCase()) ||
          itineraire.description.toLowerCase().contains(query.toLowerCase()) ||
          itineraire.difficulty.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _setState(ItinerairesState newState, {String? error}) {
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == ItinerairesState.error) {
      _setState(ItinerairesState.initial);
    }
  }

  Future<void> refresh() async {
    await loadItineraires();
  }
}