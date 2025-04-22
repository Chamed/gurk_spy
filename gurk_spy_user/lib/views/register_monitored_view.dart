import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gurk_spy_user/views/create_area.view.dart';
import '../controllers/monitored_controller.dart';
import '../models/monitored_model.dart';

class RegisterMonitoredView extends StatefulWidget {
  const RegisterMonitoredView({super.key});

  @override
  State<RegisterMonitoredView> createState() => _RegisterMonitoredViewState();
}

class _RegisterMonitoredViewState extends State<RegisterMonitoredView> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final enderecoController = TextEditingController();
  final codigoRastreioController = TextEditingController();

  List<LatLng> areaDelimitada = [];

  bool _codigoValido(String codigo) {
    final invalidCharacters = RegExp(r'[.#$\[\]/]');
    return !invalidCharacters.hasMatch(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Adicionar Monitorado',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF9EFFB),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.person_add, size: 80),
              const SizedBox(height: 30),
              _buildTextField(nomeController, 'Nome completo'),
              const SizedBox(height: 16),
              _buildTextField(idadeController, 'Idade',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(enderecoController, 'Endereço'),
              const SizedBox(height: 16),
              _buildTextField(codigoRastreioController, 'Código de Rastreio'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAreaView(),
                      ),
                    );

                    if (result != null && result is List<LatLng>) {
                      setState(() {
                        areaDelimitada = result;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Área delimitadora criada com sucesso.'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Criar área delimitadora',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final codigo = codigoRastreioController.text.trim();

                    if (!_codigoValido(codigo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'O código de rastreio contém caracteres inválidos (., #, \$, [, ], /).',
                          ),
                        ),
                      );
                      return;
                    }

                    if (areaDelimitada.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Você precisa criar uma área delimitadora.'),
                        ),
                      );
                      return;
                    }

                    final paciente = Monitored(
                      nome: nomeController.text.trim(),
                      idade: int.tryParse(idadeController.text.trim()) ?? 0,
                      endereco: enderecoController.text.trim(),
                      codigoRastreamento: codigo,
                      areaDelimitada: areaDelimitada,
                    );

                    try {
                      final controller = MonitoredController();
                      await controller.cadastrarPaciente(paciente);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paciente cadastrado com sucesso!'),
                        ),
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar: $e')),
                      );
                    }
                  },
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String hintText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
