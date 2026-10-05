import 'package:flutter/material.dart';
import '../models/pyq_model.dart';
import '../utils/constants.dart';
import 'difficulty_badge.dart';

class PYQCard extends StatefulWidget {
  final PYQModel pyq;

  const PYQCard({super.key, required this.pyq});

  @override
  State<PYQCard> createState() => _PYQCardState();
}

class _PYQCardState extends State<PYQCard> {
  bool _showExplanation = false;
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pyq = widget.pyq;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'UPSC CSE ${pyq.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pyq.subject,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    ),
                  ),
                ],
              ),
              DifficultyBadge(difficulty: pyq.difficulty),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Topic: ${pyq.topic}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pyq.questionText,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Options
          ...List.generate(pyq.options.length, (index) {
            final isChosen = _selectedOption == index;
            final isCorrect = pyq.correctOptionIndex == index;
            Color optBg = Colors.transparent;
            Color borderCol = isDark ? AppColors.borderDark : AppColors.borderLight;
            Color textCol = theme.textTheme.bodyMedium?.color ?? Colors.black;

            if (_showExplanation) {
              if (isCorrect) {
                optBg = AppColors.success.withOpacity(0.15);
                borderCol = AppColors.success;
                textCol = AppColors.success;
              } else if (isChosen && !isCorrect) {
                optBg = AppColors.error.withOpacity(0.15);
                borderCol = AppColors.error;
                textCol = AppColors.error;
              }
            } else if (isChosen) {
              optBg = (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.1);
              borderCol = isDark ? AppColors.secondaryOrange : AppColors.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _selectedOption = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: optBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderCol, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: borderCol.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textCol,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          pyq.options[index],
                          style: TextStyle(fontSize: 13, color: textCol),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: Icon(
                  _showExplanation ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 16,
                ),
                label: Text(_showExplanation ? 'Hide Solution' : 'Show Solution & Answer'),
                onPressed: () {
                  setState(() {
                    _showExplanation = !_showExplanation;
                  });
                },
              ),
              if (_selectedOption != null && !_showExplanation)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() {
                      _showExplanation = true;
                    });
                  },
                  child: const Text('Check', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          if (_showExplanation) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Correct Option: (${String.fromCharCode(65 + pyq.correctOptionIndex)})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pyq.explanation,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
