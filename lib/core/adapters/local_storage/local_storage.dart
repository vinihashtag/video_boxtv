import 'package:get_storage/get_storage.dart';

import '../../utils/helpers.dart';
import 'local_storage_adapter.dart';

class LocalStorageAdapter implements ILocalStorageAdapter {
  final GetStorage _box = GetStorage();

  @override
  Future<void> write(String key, dynamic value) async {
    try {
      await _box.write(key, value);
    } catch (e, s) {
      Helpers.error(identifier: '[LOCALSTORAGE][WRITE]', e, s);
      throw Exception('Erro ao gravar o registro: $key');
    }
  }

  @override
  T? read<T>(String key) {
    try {
      return _box.read<T>(key);
    } catch (e, s) {
      Helpers.error(identifier: '[LOCALSTORAGE][READ]', e, s);
      throw Exception('Erro ao retornar o registro: $key');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _box.remove(key);
    } catch (e, s) {
      Helpers.error(identifier: '[LOCALSTORAGE][REMOVE]', e, s);
      throw Exception('Erro ao remover o registro: $key');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _box.erase();
    } catch (e, s) {
      Helpers.error(identifier: '[LOCALSTORAGE][CLEAR]', e, s);
      throw Exception('Erro ao limpar todos os dados locais');
    }
  }
}
