import 'dart:developer';
import 'package:get/get.dart';
import 'package:projeto_agendamento/repository/service_repository.dart';
import '../model/servico_model.dart';

class ServiceController extends GetxController {
  final _repo = ServiceRepository();

  final services = <ServicoModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load([String? q]) async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await _repo.getAll(q: (q ?? query.value));
      services.assignAll(list as Iterable<ServicoModel>);
    } catch (e) {
      error.value = 'Falha ao carregar: $e';
    } finally {
      isLoading.value = false;
    }
  }

  String? validade({
    required String name,
    required String durationStr,
    required String priceStr,
  }) {
    if (name.trim().isEmpty) return 'Nome é obritatório.';

    final price = double.tryParse(priceStr.replaceAll(',', '.'));
    if (price == null || price < 0) return 'Preço inválido.';

    final stock = int.tryParse(durationStr);
    if (stock == null || stock < 0) return 'Duração inválida.';

    return null;
  }

  Future<bool> create({
    required String nome,
    required double preco,
    required int duracaoMinutos,
  }) async {
    try {
      isLoading.value = true;
      final service = ServicoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: nome,
        duracaoMinutos: duracaoMinutos,
        preco: preco,
      );

      await _repo.create(service as Service);
      await load();

      return true;
    } catch (e) {
      error.value = 'Falha ao salvar: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateService(Service service) async {
    try {
      isLoading.value = true;
      await _repo.update(service);
      await load();
      return true;
    } catch (e) {
      error.value = 'Falha ao atualizar: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(int id) async {
    try {
      isLoading.value = true;
      await _repo.delete(id);
      await load();
    } catch (e) {
      error.value = 'Falha ao deletar: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
