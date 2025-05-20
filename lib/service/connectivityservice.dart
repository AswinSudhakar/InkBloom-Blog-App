import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_checkStatus);
    _checkInitialConnection();
  }

  void _checkInitialConnection() async {
    var result = await _connectivity.checkConnectivity();
    _checkStatus(result);
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;

    if (result != ConnectivityResult.none) {
      try {
        final lookupResult = await InternetAddress.lookup('example.com');
        isOnline =
            lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        isOnline = false;
      }
    }

    _connectionStatusController.add(isOnline);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
