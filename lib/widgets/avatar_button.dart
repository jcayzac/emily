import 'package:flutter/material.dart';

class AvatarButton extends StatelessWidget {
  final Image image;
  final VoidCallback onTap;
  final double size;
  final Color backgroundColor;
  final Color rippleColor;

  AvatarButton({
    Key key,
    @required this.image,
    @required this.onTap,
    @required this.size,
    this.backgroundColor = Colors.black12,
    this.rippleColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
      child: Material(
          type: MaterialType.circle,
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).colorScheme.surface,
          elevation: Theme.of(context).cardTheme.elevation ?? 8.0,
          borderOnForeground: true,
          child: Container(
            width: size,
            height: size,
            child: InkWell(
              radius: size,
              splashColor: Theme.of(context).colorScheme.onSurface,
              child: image,
              onTap: onTap,
            ),
          )));
}
