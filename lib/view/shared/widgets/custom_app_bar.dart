import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.automaticallyImplyLeading,
      required this.title,
      this.leading,
      this.bgColor,
      this.actions,
      this.bottom});

  final String title;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  final Color? bgColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      leading: leading,
      actions: actions,
      elevation: 1,
      shadowColor: Colors.black,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18),
        overflow: TextOverflow.fade,
      ),
      backgroundColor: bgColor,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
