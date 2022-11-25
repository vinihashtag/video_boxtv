import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get/get.dart';

import '../enums/network_info_enum.dart';

class ConnectivityController extends GetxController {
  final Connectivity _dataConnectionChecker = Connectivity();

  ConnectivityController() {
    _hasConnection();
  }

  // parameters
  StreamSubscription? _subscription;
  final _isConnected = false.obs;
  final _typeConnection = NetworkInfoType.none.obs;

  // getters
  bool get isConnected => _isConnected.value;
  RxBool get rxConnected => _isConnected;
  NetworkInfoType get typeConnection => _typeConnection.value;

  // * Make first request of status of connection and open stream
  Future<void> _hasConnection() async {
    try {
      await _dataConnectionChecker.checkConnectivity().then(_mapperEventNetwork);

      _subscription = _dataConnectionChecker.onConnectivityChanged.listen(_mapperEventNetwork);
    } catch (e) {
      log('[ERROR/NetworkInfoController/_hasConnection] => $e');
    }
  }

  // * Mapper to result of connection
  void _mapperEventNetwork(ConnectivityResult event) {
    switch (event) {
      case ConnectivityResult.bluetooth:
        _typeConnection.value = NetworkInfoType.bluetooth;
        _isConnected.value = false;
        break;
      case ConnectivityResult.wifi:
        _typeConnection.value = NetworkInfoType.wifi;
        _isConnected.value = true;
        break;
      case ConnectivityResult.ethernet:
        _typeConnection.value = NetworkInfoType.ethernet;
        _isConnected.value = true;
        break;
      case ConnectivityResult.mobile:
        _typeConnection.value = NetworkInfoType.mobile;
        _isConnected.value = true;
        break;
      case ConnectivityResult.none:
        _typeConnection.value = NetworkInfoType.none;
        _isConnected.value = false;
        break;
      case ConnectivityResult.vpn:
        _typeConnection.value = NetworkInfoType.vpn;
        _isConnected.value = true;
        break;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
