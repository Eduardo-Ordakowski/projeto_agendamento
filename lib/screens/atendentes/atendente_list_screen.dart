import 'package:flutter/material.dart';
import 'package:projeto_agendamento/model/atendente_model.dart';
import 'package:projeto_agendamento/screens/atendentes/atendente_form_screen.dart';
import 'package:projeto_agendamento/services/atendentes_service.dart';

class AtendenteListScreen extends StatelessWidget{
  final _atendenteService = AtendenteService();

  AtendenteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atendentes'),
          backgroundColor: Colors.green,
      ),

      body: StreamBuilder<List<AtendenteModel>>(
        stream: _atendenteService.getAllAtendentes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Erro ao carregar atendentes',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum atendente cadastrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no + para adicionar',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          List<AtendenteModel> atendentes = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: atendentes.length,
            itemBuilder: (context, index) {
              AtendenteModel atendente = atendentes[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: atendente.ativo
                      ? Colors.green
                      : Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    atendente.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: atendente.ativo
                        ? null
                        : TextDecoration.lineThrough,
                    ),
                  ),
              
                  subtitle: Text(
                    atendente.especialidade ?? 'Sem especialidade',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),  
              
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AtendenteFormScreen(
                                atendente: atendente,
                              ),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(
                          atendente.ativo ? Icons.toggle_on : Icons.toggle_off,
                          color: atendente.ativo ? Colors.green: Colors.grey,
                          size: 32,
                        ),
                        tooltip: atendente.ativo ? 'Desativar' : 'Ativar',
                        onPressed: () async {
                          _showToggleDialog(context, atendente);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Adicionar Atendente',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AtendenteFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showToggleDialog(BuildContext context, AtendenteModel atendente) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            atendente.ativo ? 'Desativar Atendente' : 'Reativar Atendente',
          ),
          content: Text(
            atendente.ativo
              ? 'Atendente ${atendente.nome} desativado'
              : 'Atendente ${atendente.nome} reativado',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (atendente.ativo) {
                    await _atendenteService.softDeleteAtendente(atendente.id);
                  } else {
                    await _atendenteService.reactivateAtendente(atendente.id);
                  }

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        atendente.ativo
                          ? 'Atendente desativado'
                          : 'Atendente reativado',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao alterar status'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },

              child: Text(
                atendente.ativo ? 'Desativar' : 'Reativar',
                style: TextStyle(
                  color: atendente.ativo ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}