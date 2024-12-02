import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../utils/defaults.dart';
import '../../utils/gaps.dart';
import '../../utils/responsive.dart';


class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.color = AppColors.secondaryPeach,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDefaults.borderRadius / 3)),
          ),
        ),
        gapW8,
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.isDesktop(context) ? null : 20,
              ),
        )
      ],
    );
  }
}
