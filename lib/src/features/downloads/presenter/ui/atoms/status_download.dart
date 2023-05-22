import 'package:flutter/material.dart';

class StatusDownload extends StatelessWidget {
  final bool finalizado;
  final bool pausado;

  const StatusDownload({super.key, required this.finalizado, required this.pausado});
  @override
  Widget build(BuildContext context) {
    if (finalizado) {
      return const Icon(
        Icons.done,
        color: Colors.green,
        size: 38,
      );
    }
    if (pausado) {
      return const Icon(
        Icons.stop_circle_outlined,
        color: Colors.blue,
        size: 38,
      );
    } else {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.red,
        ),
      );
    }
  }
}
