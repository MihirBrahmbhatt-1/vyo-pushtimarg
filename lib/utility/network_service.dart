import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final RxBool isConnected = true.obs;
  final RxBool isPoorConnection = false.obs;

  late StreamSubscription _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final result = results.lastOrNull ?? ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      isPoorConnection.value = false;
    } else {
      isConnected.value = true;
      // Assume poor until request proves otherwise
      isPoorConnection.value = false;
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
