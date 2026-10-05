import 'package:flutter/material.dart';
import '../models/educator_model.dart';
import '../utils/constants.dart';

class EducatorCard extends StatelessWidget {
  final EducatorModel educator;
  final VoidCallback onTap;
  final bool isHorizontal;

  const EducatorCard({
    super.key,
    required this.educator,
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardContent = Container(
      width: isHorizontal ? 200 : double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Educator Avatar Placeholder
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primary,
                backgroundImage: educator.imageUrl != null
                    ? AssetImage(educator.imageUrl!)
                    : null,
                child: educator.imageUrl == null
                    ? Text(
                        educator.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, size: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            educator.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            educator.subject,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.secondaryOrange : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            educator.experience,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 3),
              Text(
                '${educator.rating}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '• ${educator.studentCount}',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return isHorizontal
        ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: cardContent,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: cardContent,
            ),
          );
  }
}
