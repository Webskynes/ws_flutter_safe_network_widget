import 'package:flutter/material.dart';
import 'package:ws_flutter_safe_network_widget/src/bloc.dart';
import 'package:ws_flutter_safe_network_widget/src/enum.dart';

class NetworkSafeWidget extends StatefulWidget {
  const NetworkSafeWidget({
    required this.child,
    this.alertType = NetworkAlertType.snackbar,
    super.key,
  });

  final Widget child;
  final NetworkAlertType alertType;

  @override
  State<NetworkSafeWidget> createState() => _NetworkSafeWidgetState();
}

class _NetworkSafeWidgetState extends State<NetworkSafeWidget> {
  final bloc = SafeNetworkBloc();

  @override
  void initState() {
    super.initState();
    bloc.initializeConnectivityListener();
  }

  bool isErrorWidgetVisible = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.connectionStream,
        builder: (ctx, snapshot) {
          final connected = snapshot.data ?? false;
          if (!connected) {
            isErrorWidgetVisible = true;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  content: Text('No internet connection'),
                ),
              );
            });

            // showBottomSheet(
            //     context: context,
            //     builder: (ctx) {
            //       return Container();
            //     });
          }
          if (connected && isErrorWidgetVisible) {
            isErrorWidgetVisible = false;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.white,
                  showCloseIcon: true,
                  behavior: SnackBarBehavior.floating,
                  closeIconColor: Colors.black,
                  content: Text(
                    'Connection Restored!',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            });

            // showBottomSheet(
            //     context: context,
            //     builder: (ctx) {
            //       return Container();
            //     });
          }
          return widget.child;
        });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
