import 'package:flutter/material.dart';
import 'package:gurk_spy_user/controllers/home_controller.dart';
import 'package:gurk_spy_user/views/register_monitored_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();
  List<Map<String, dynamic>> monitoredUsers = [];
  String userName = 'Usuário';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _controller.getUserData();
    final usersData = await _controller.getMonitoredUsers();

    setState(() {
      if (userData != null && userData['nome'] != null) {
        userName = userData['nome'];
      }
      monitoredUsers = usersData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Monitorados'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _controller.signOut(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Olá, $userName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        monitoredUsers.isEmpty
                            ? const Center(
                              child: Text(
                                'Nenhum monitorado encontrado.',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                            : ListView.builder(
                              itemCount: monitoredUsers.length,
                              itemBuilder: (context, index) {
                                final user = monitoredUsers[index];
                                final bool isActive = user['status'] == 'ativo';

                                return ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color:
                                        Colors
                                            .green, // DEIXEI ESSA FUNCIONALIDADE PARA DEPOIS isActive ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  title: Text(user['nome'] ?? 'Sem nome'),
                                  subtitle: Text(
                                    'Status: Ativo',
                                  ), //${user['status']}
                                );
                              },
                            ),
                  ),
                ],
              ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder:
                          (_, __, ___) => const RegisterMonitoredView(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutQuad,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );

                  if (resultado == true) {
                    _loadUserData();
                  }
                },

                icon: const Icon(Icons.person_add_alt_1, size: 24),
                label: const Text(
                  'Adicionar Monitorado',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 55, 102),
                  iconColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blue[800]!.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
