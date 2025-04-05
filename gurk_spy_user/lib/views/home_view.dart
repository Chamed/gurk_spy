import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  final List<String> users = [];

  HomeView({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Monitorados'),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? Center(
              child: Text(
                'Nenhum usuário encontrado.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]),
                );
              },
            ),
    );
  }
}