import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final String imageName;
  final VoidCallback onTap;

  ActionButton({
    Key key,
    @required this.imageName,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: OutlineButton(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 4.0,
          ),
        ),
        color: Theme.of(context).colorScheme.surface,
        focusColor: Theme.of(context).accentColor,
        //hoverColor: Theme.of(context).buttonColor,
        highlightColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        splashColor: Theme.of(context).splashColor,
        child: Row(
          children: [
            Image.asset(
              "assets/$imageName.png",
              width: Theme.of(context).buttonTheme.height,
              height: Theme.of(context).buttonTheme.height,
            ),
            Flexible(
                child: Padding(
              padding: EdgeInsetsDirectional.only(start: 8),
              child: Text(
                label,
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            )),
          ],
        ),
        onPressed: onTap,
      ));
}
