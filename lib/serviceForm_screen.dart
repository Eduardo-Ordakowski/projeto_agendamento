import 'dart:developer';

import 'package:flutter/material.dart';

class ServiceFormScreen extends StatefulWidget {
    final Service? service;
    const ServiceFormScreen({super.key, this.service});

    @override
    State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class StatefulWidget {
}

class State {
}

class _ServiceFormsStateFields {
    final nameCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    
    void dispose() {
        nameCtrl.dispose();
        durationCtrl.dispose();
        priceCtrl.dispose();
    }    
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
    final c = Get.find<ServiceController>();
    final f = _ServiceFormsStateFields();

    @override
    void initState() {
        super.initState();
        final p = widget.service;

        if (p != null) {
            f.nameCtrl.text = p.name;
            f.durationCtrl.text = p.durationMinutes.toString();
            f.priceCtrl.text = p.price.toStringAsFixed(2);
        }
    }

    @override
    void dispose() {
        f.dispose();
        super.dispose();
    }

    @override
    Widget build (BuildContext context) {
        final isEdit = widget.service != null;
        return Scaffold(
            appBar: AppBar(tittle: Text(isEdit ? 'Editar Serviço' : 'Cadastrar Serviço')),
            body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
                children: [
                    TextField(
                        controller: f.nameCtrl,
                        decoration: const InputDecoration(labelText: 'Nome *'),
                    ),
                    const SizedBox(height: 12),
                    )
                    TextField(
                        controller: f.durationCtrl,
                        decoration: const InputDecoration(labelText: 'Duração (min) *'),
                    ),
                    const SizedBox(height: 12),
                    )
                    TextField(
                        controller: f.priceCtrl,
                        decoration: const InputDecoration(labelText: 'Preço (R\$) *'),
                    ),
                    const SizedBox(height: 24),
                    Obx(() => ElevatedButton.icon(
                        icon: c.isLoading.value ? 
                            ? const SizedBox( width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.save),
                            label: Text(isEdit ? 'Atualizar serviço' :'Cadastrar serviço'),
                            onPressed: c.isLoading.value
                                ? null
                                : () async {
                                    final error = c.validade(
                                        name: f.nameCtrl.text,
                                        durationStr: f.durationCtrl.text,
                                        priceStr: f.priceCtrl.text,
                                    );
                                    if (error != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                                        return;
                                    }
                                    final price = double.parse(f.priceCtrl.text.replaceAll(',', '.'));
                                    final duration = int.parse(f.durationCtrl.text);

                                    if(isEdit) {
                                        final updatedService = widget.service!.copyWith(
                                            name: f.nameCtrl.text,
                                            durationMinutes: duration,
                                            price: price,
                                        );
                                        final ok = await c.updateService(updatedService);
                                        if (ok && context.mounted) {
                                            Navigator.pop(context, true);
                                        } else {
                                            final ok = await c.create(
                                                name: f.nameCtrl.text,
                                                durationMinutes: duration,
                                                price: price,
                                            );
                                            if (ok && context.mounted) {
                                                Navigator.pop(context, true);
                                            }
                                        }
                                    }
                                }

                        )
                    )
                    )
                ],
            ),
        );
    }
}