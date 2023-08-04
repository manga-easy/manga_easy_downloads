import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';

class ContainerChapterDownload extends StatelessWidget {
  final String chapters;
  final String pages;
  final List<Widget> icons;
  const ContainerChapterDownload(
      {super.key,
      required this.icons,
      required this.chapters,
      required this.pages});

  String convertPage(String page) {
    if (page.toString() == '1') {
      return '${page.padLeft(2, '0')} página';
    }
    return '${page.padLeft(2, '0')} páginas';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CoffeeContainer(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoffeeText(
                  text: 'Capítulo ${chapters.toString().padLeft(2, '0')}',
                  typography: CoffeeTypography.button,
                ),
                CoffeeText(
                  text: convertPage(pages),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: icons,
            ),
          ],
        ),
      ),
    );
  }
}
