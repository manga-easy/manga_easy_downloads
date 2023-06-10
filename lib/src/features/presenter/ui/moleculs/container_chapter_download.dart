import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';

class ContainerChapterDownload extends StatelessWidget {
  final int chapter;
  final int page;
  final List<Widget> icons;
  const ContainerChapterDownload(
      {super.key,
      required this.icons,
      required this.chapter,
      required this.page});

  String convertPage(int page) {
    if (page.toString() == '1') {
      return '${page.toString().padLeft(2, '0')} página';
    }
    return '${page.toString().padLeft(2, '0')} páginas';
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
                    text: 'Capítulo ${chapter.toString().padLeft(2, '0')}',
                    typography: CoffeeTypography.button),
                CoffeeText(
                  text: convertPage(3),
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
