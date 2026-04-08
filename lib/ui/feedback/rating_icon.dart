import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// An icon button representing a single [FeedbackRating] sentiment option.
///
/// Renders as a coloured icon button: highlighted with the secondary colour
/// when [isSelected] is `true`, grey otherwise.
class RatingIcon extends StatelessWidget {
  const RatingIcon({
    required this.rating,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final FeedbackRating rating;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    switch (rating) {
      case FeedbackRating.bad:
        icon = Icons.sentiment_dissatisfied;
        break;
      case FeedbackRating.neutral:
        icon = Icons.sentiment_neutral;
        break;
      case FeedbackRating.good:
        icon = Icons.sentiment_satisfied;
        break;
    }
    return IconButton(
      color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey,
      onPressed: onTap,
      icon: Icon(icon),
      iconSize: 36,
    );
  }
}
