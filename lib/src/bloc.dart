import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

class SafeNetworkBloc {
  late StreamSubscription connectivity;

  final _connection = BehaviorSubject<bool>();

  ValueStream<bool> get connectionStream => _connection.stream;

  void initializeConnectivityListener() {
    connectivity = Connectivity().onConnectivityChanged.listen((event) async {
      final isConnected = await InternetConnectionChecker().hasConnection;
      _connection.add(isConnected);
    });
  }

  void dispose() {
    connectivity.cancel();
    _connection.close();
  }
}
