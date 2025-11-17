import 'package:flutter/material.dart';
import 'package:projeto_agendamento/model/servico_model.dart';
import 'package:projeto_agendamento/screens/servicos/servico_form_screen.dart';
import 'package:projeto_agendamento/services/servico_service.dart';
  
class ServicoListScreen extends StatelessWidget{
  final _servicoService = ServicoService();

  ServicoListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serviços'),
          backgroundColor: Colors.orange,
      ),
      
      body: StreamBuilder<List<ServicoModel>> (
        stream: _servicoService.getServicosAsync(),
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
                    'Erro ao carregar serviços',
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
                  Icon(Icons.sell_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum serviços cadastrado',
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

          List<ServicoModel> servicos = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: servicos.length,
            itemBuilder: (context, index) {
              ServicoModel servico = servicos[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: servico.ativo
                      ? Colors.green
                      : Colors.grey,
                    child: Icon(
                      Icons.sell_rounded,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    servico.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: servico.ativo
                        ? null
                        : TextDecoration.lineThrough,
                    ),
                  ),
              
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        '${servico.duracaoMinutos} minutos',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),                    

                      SizedBox(height: 4),
                      
                      Text(
                        'R\$ ${servico.preco.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                              builder: (context) => ServicoFormScreen(
                                servico: servico,
                              ),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(
                          servico.ativo ? Icons.toggle_on : Icons.toggle_off,
                          color: servico.ativo ? Colors.green: Colors.grey,
                          size: 32,
                        ),
                        tooltip: servico.ativo ? 'Desativar' : 'Ativar',
                        onPressed: () async {
                          _showToggleDialog(context, servico);
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
        tooltip: 'Adicionar serviço',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServicoFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showToggleDialog(BuildContext context, ServicoModel servico) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            servico.ativo ? 'Desativar Serviço' : 'Reativar Serviço',
          ),
          content: Text(
            servico.ativo
              ? 'Serviço ${servico.nome} desativado'
              : 'Serviço ${servico.nome} reativado',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (servico.ativo) {
                    await _servicoService.softDeleteServico(servico.id);
                  } else {
                    await _servicoService.reactivateServico(servico.id);
                  }

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        servico.ativo
                          ? 'servico desativado'
                          : 'servico reativado',
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
                servico.ativo ? 'Desativar' : 'Reativar',
                style: TextStyle(
                  color: servico.ativo ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}