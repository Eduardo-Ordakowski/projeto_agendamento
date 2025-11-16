import 'package:flutter/material.dart';
import 'package:projeto_agendamento/model/atendente_model.dart';
import 'package:projeto_agendamento/services/atendentes_service.dart';

class AtendenteFormScreen extends StatefulWidget {
  
  final AtendenteModel? atendente;
  const AtendenteFormScreen({super.key, this.atendente});

  @override
  State<AtendenteFormScreen> createState() => _AtendenteFormScreenState();
}

class _AtendenteFormScreenState extends State<AtendenteFormScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _atendenteService = AtendenteService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if(widget.atendente != null) {
      _nomeController.text = widget.atendente!.nome;
      _especialidadeController.text = widget.atendente!.especialidade ?? '';
    }
  }

  @override 
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.atendente == null) {
        await _atendenteService.createAtendente(
          nome: _nomeController.text.trim(),
          especialidade: _especialidadeController.text.trim().isEmpty
              ? null
              : _especialidadeController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Atendente cadastrado com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        AtendenteModel atendenteAtualizado = AtendenteModel(
          id: widget.atendente!.id,
          nome: _nomeController.text.trim(),
          especialidade: _especialidadeController.text.trim().isEmpty
              ? null
              : _especialidadeController.text.trim(),
          ativo: widget.atendente!.ativo,
        );

        await _atendenteService.updateAtendente(atendenteAtualizado);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Atendente atualizado com sucesso.'),
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
            content: Text('Erro ao salvar atendente: $e'),
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
  Widget build(BuildContext context) {

    bool isEdicao = widget.atendente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar atendente' : 'Novo antendente'),
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
                  labelText: 'Nome do atendente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome do atendente.';
                  }
                  if (value.trim().length < 3) {
                    return 'O nome deve ter pelo menos 3 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),

              TextFormField(
                controller: _especialidadeController,
                decoration: InputDecoration(
                  labelText: 'Especialidade (opcional)',
                  hintText: 'Ex: Cabelereiro, Barbeiro...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                  helperText: 'Deixe em branco se não houver especialidade.',
                ),
                textCapitalization: TextCapitalization.words,
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
