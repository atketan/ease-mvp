import 'package:flutter/material.dart';

import '../data/icon_data.dart';

class IconSelector extends StatefulWidget {
  final Function(String) onIconSelected;

  IconSelector({required this.onIconSelected});

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  String? _selectedIconName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: iconDataMap.length,
          itemBuilder: (context, index) {
            final iconName = iconDataMap.keys.elementAt(index);
            final icon = iconDataMap[iconName];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIconName = iconName;
                });
                widget.onIconSelected(iconName);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedIconName == iconName
                        ? Theme.of(context).primaryColorDark
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon),
              ),
            );
          },
        ),
        if (_selectedIconName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(text: 'Selected Icon: '),
                  TextSpan(
                    text: _selectedIconName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
