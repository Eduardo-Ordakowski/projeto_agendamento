import 'package:flutter/material.dart';
import 'package:projeto_agendamento/model/servico_model.dart';
import 'package:projeto_agendamento/services/servico_service.dart';

class ServicoFormScreen extends StatefulWidget {

  final ServicoModel? servico;
  const ServicoFormScreen({super.key, this.servico});

  @override
  State<ServicoFormScreen> createState() => _ServicoFormScreenState();

}

class _ServicoFormScreenState extends State<ServicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _duracaoMinutosController = TextEditingController();
  final _precoController = TextEditingController();
  final _servicoService = ServicoService();
  bool _isLoading = false;

  @override 
  void initState() {
    super.initState();

    if(widget.servico != null) {
      _nomeController.text = widget.servico!.nome;
      _duracaoMinutosController.text = widget.servico!.duracaoMinutos.toString();
      _precoController.text = widget.servico!.preco.toStringAsFixed(2);
    }
  }

  @override
  void dispose () {
    _nomeController.dispose();
    _duracaoMinutosController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() => _isLoading = true); 

    try {
      String precoClean = _precoController.text.trim()
        .replaceAll('R\$', '')
        .replaceAll(',', '.')
        .trim();
        
      if (widget.servico == null) {
        await _servicoService.createServico(
          nome: _nomeController.text.trim(),
          duracaoMinutos: int.parse(_duracaoMinutosController.text.trim()),
          preco: double.parse(precoClean),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Serviço cadastrado com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        ServicoModel servicoAtualizado = ServicoModel(
          id: widget.servico!.id,
          nome: _nomeController.text.trim(),
          duracaoMinutos: int.parse(_duracaoMinutosController.text.trim()),
          preco: double.parse(precoClean),
          ativo: widget.servico!.ativo,
        );

        await _servicoService.updateServico(servicoAtualizado);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Serviço atualizado com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar o serviço.'),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override 
  Widget build (BuildContext context) {

    bool isEdicao = widget.servico != null; 

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar serviço' : 'Novo serviço'),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do serviço',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.room_service),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome do serviço.';
                  }
                  if (value.trim().length < 3) {
                    return 'O nome deve ter pelo menos 3 caracteres.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16,),
              
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(
                  labelText: 'Preço do serviço',
                  hintText: 'Ex: 49.90',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o preço do serviço.';
                  }

                  String cleanValue = value.trim().replaceAll('R\$', '').replaceAll(',', '.');
                  final preco = double.tryParse(cleanValue);

                  if (preco == null) {
                    return 'Digite um valor numérico válido para o preço.';
                  }

                  if (preco < 0) {
                    return 'O preço não pode ser negativo.';
                  }

                  if (preco > 10000) {
                    return 'O preço máximo permitido é R\$ 10.000,00.';
                  }

                  return null; 
                },
              ),

              SizedBox(height: 16,),

              TextFormField(
                controller: _duracaoMinutosController,
                decoration: InputDecoration(
                  labelText: 'Duração (minutos)',
                  hintText: 'Ex: 30, 60...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                  helperText: 'Duração em minutos'
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a duração do serviço em minutos.';
                  }

                  final duracao = int.tryParse(value.trim());
                  
                  if (duracao == null || duracao <= 0) {
                    return 'A duração deve ser um número positivo.';
                  }

                  if(duracao > 480) {
                    return 'Duração máxima é de 480 minutos.';
                  }
                  return null; 
                },
              ),

              SizedBox(height: 24),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.green[200], 
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdicao ? 'Atualizar' : 'Cadastrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}