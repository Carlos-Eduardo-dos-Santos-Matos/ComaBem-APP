import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color corFundo;
  final IconData? icone;

  const BotaoCustomizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.corFundo = const Color(0xFFFF4500),
    this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: icone != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icone, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(texto, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ],
              )
            : Text(texto, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}