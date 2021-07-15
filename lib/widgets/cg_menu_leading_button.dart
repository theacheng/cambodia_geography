import 'dart:io';

import 'package:cambodia_geography/exports/exports.dart';

class CgMenuLeadingButton extends StatelessWidget {
  const CgMenuLeadingButton({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: animationController,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
  }
}
