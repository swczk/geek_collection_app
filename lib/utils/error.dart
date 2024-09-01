import 'package:flutter/material.dart';

class Erro extends StatefulWidget {
  const Erro(
      {super.key,
      required this.icon,
      this.size = 24.0,
      required this.mensagem});

  final IconData icon;
  final double? size;
  final String mensagem;

  @override
  State<Erro> createState() => _ErroState();
}

class _ErroState extends State<Erro> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD22828),
      padding: const EdgeInsets.all(1.0),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: Colors.white,
                size: widget.size,
              ),
              Text(
                ' ${widget.mensagem}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ]),
      ),
    );
  }
}
