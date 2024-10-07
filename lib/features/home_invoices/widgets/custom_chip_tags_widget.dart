import 'package:flutter/material.dart';

class CustomChipTagsWidget extends StatelessWidget {
  final String tagTitle;
  final Color? tagColor;

  const CustomChipTagsWidget(
      {super.key, required this.tagTitle, required this.tagColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.circle_outlined,
          color: tagColor,
          size: 18,
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          tagTitle,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: tagColor, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
