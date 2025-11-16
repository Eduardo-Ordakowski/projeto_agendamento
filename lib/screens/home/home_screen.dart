import 'package:flutter/material.dart';
import 'package:projeto_agendamento/model/user_model.dart';
import 'package:projeto_agendamento/screens/atendentes/atendente_list_screen.dart';
import 'package:projeto_agendamento/services/auth_service.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  final _authService = AuthService();

  HomeScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    try {
      await _authService.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer logout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user.nome}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.blue),
                title: Text('Agendamentos'),
                subtitle: Text('Ver e gerenciar agendamentos'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Em desenvolvimento...')),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.green),
                title: Text('Atendentes'),
                subtitle: Text('Gerenciar atendentes'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AtendenteListScreen(),
                    )
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.room_service, color: Colors.orange),
                title: Text('Serviços'),
                subtitle: Text('Gerenciar serviços'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Em desenvolvimento...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}