import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/helpers.dart';
import 'secure_storage_adapter.dart';

class SecureStorageAdapter implements ISecureStorageAdapter {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> write(String key, String value) async {
    try {
      return await _secureStorage.write(key: key, value: value);
    } catch (e, s) {
      Helpers.error(identifier: '[LocalStorageAdapterImpl][write]', e, s);
      throw Exception('Erro ao gravar o registro: $key');
    }
  }

  @override
  Future<String?> read(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e, s) {
      Helpers.error(identifier: '[LocalStorageAdapterImpl][read]', e, s);
      throw Exception('Erro ao retornar o registro: $key');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e, s) {
      Helpers.error(identifier: '[LocalStorageAdapterImpl][remove]', e, s);
      throw Exception('Erro ao remover o registro: $key');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e, s) {
      Helpers.error(identifier: '[LocalStorageAdapterImpl][clear]', e, s);
      throw Exception('Erro ao limpar todos os dados seguros');
    }
  }
}
