import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final List<PopupMenuEntry<dynamic>> listPopMenu;
  final TextEditingController textController;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final void Function() cleanSearch;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.listPopMenu,
    required this.textController,
    required this.onChanged,
    this.keyboardType,
    required this.cleanSearch,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeService.of.backgroundColor,
      elevation: 0,
      leading: CoffeeIconButton(
        icon: Icons.arrow_back_ios_new_outlined,
        onTap: () => Navigator.pop(context),
        size: 24,
      ),
      title: isSearch
          ? CoffeeSearchField(
              controller: widget.textController,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              suffixIcon: CoffeeIconButton(
                icon: Icons.close,
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                    widget.cleanSearch();
                  });
                },
              ),
            )
          : CoffeeText(
              text: widget.title,
              typography: CoffeeTypography.title,
            ),
      actions: [
        isSearch
            ? const SizedBox.shrink()
            : CoffeeIconButton(
                icon: Icons.search,
                size: 30,
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
              ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: ThemeService.of.backgroundIcon,
          ),
          itemBuilder: (context) => widget.listPopMenu,
        ),
      ],
    );
  }
}
