import 'package:flutter/material.dart';

class Helpers {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Formater une durée (ex: "2h30")
  static String formatDuration(String duration) {
    return duration;
  }

  /// Formater une distance (ex: "5 km")
  static String formatDistance(String? distance) {
    if (distance == null || distance.isEmpty) return '';
    return distance;
  }

  static String getErrorMessage(dynamic error) {
    String message = error.toString();

    message = message.replaceAll('Exception: ', '');
    message = message.replaceAll('Error: ', '');

    if (message.contains('SocketException') ||
        message.contains('connexion') ||
        message.contains('Internet')) {
      return 'Vérifiez votre connexion Internet';
    }

    if (message.contains('TimeoutException') ||
        message.contains('timeout')) {
      return 'La requête a pris trop de temps';
    }

    if (message.contains('FormatException')) {
      return 'Erreur de format des données';
    }

    return message.isNotEmpty
        ? message
        : 'Une erreur est survenue';
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}