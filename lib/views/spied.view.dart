// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gurk_spy/controllers/spied.controller.dart';

class SpiedView extends StatefulWidget {
  const SpiedView({super.key});

  @override
  State<SpiedView> createState() => _SpiedViewState();
}

class _SpiedViewState extends State<SpiedView> {
  final SpiedController _controller = SpiedController();
  final TextEditingController _textController = TextEditingController();
  String? _spied;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initDatabase();
    final spied = await _controller.getSpied();
  
    setState(() {
      _spied = spied;
    });
  }

  Future<void> _buscarUsuario() async {
    final code = _textController.text.trim();
  
    if (code.isNotEmpty) {
      try {
        await _controller.fetchSpied(code);
        final monitorado = await _controller.getSpied();
        setState(() {
          _spied = monitorado;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _desconectar() async {
    await _controller.desconect();
    setState(() {
      _spied = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento'),
      ),
      body: Center(
        child: _spied == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Insira código do monitorado:'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Código',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _buscarUsuario,
                    child: const Text('Buscar'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.green[100],
                    child: Text(
                      'Monitoramento ativo: $_spied',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _desconectar,
                    child: const Text('Desconectar'),
                  ),
                ],
              ),
      ),
    );
  }
}