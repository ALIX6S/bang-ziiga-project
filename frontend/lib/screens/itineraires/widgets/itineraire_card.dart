import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/itineraire.dart';
import '../../../core/config/colors.dart';

class ItineraireCard extends StatelessWidget {
  final Itineraire itineraire;
  final VoidCallback onTap;

  const ItineraireCard({
    Key? key,
    required this.itineraire,
    required this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor() {
    switch (itineraire.difficulty.toLowerCase()) {
      case 'facile':
        return AppColors.sage;
      case 'moyen':
        return AppColors.moss;
      case 'intense':
        return AppColors.evergreen;
      default:
        return AppColors.moss;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: itineraire.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 160,
                  color: AppColors.sageHint,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.sage,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 160,
                  color: AppColors.sageHint,
                  child: Icon(
                    Icons.route,
                    size: 48,
                    color: AppColors.sage.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            
            // Contenu
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom
                  Text(
                    itineraire.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Infos (durée, difficulté, nombre de sites)
                  Row(
                    children: [
                      // Durée
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.moss,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        itineraire.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Difficulté
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          itineraire.difficulty,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getDifficultyColor(),
                          ),
                        ),
                      ),
                      const Spacer(),
                      
                      // Nombre de sites
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.evergreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place,
                              size: 12,
                              color: AppColors.evergreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${itineraire.sitesCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.evergreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}