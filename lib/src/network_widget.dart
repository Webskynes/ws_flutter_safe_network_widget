import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ws_flutter_safe_network_widget/src/bloc.dart';
import 'package:ws_flutter_safe_network_widget/src/enum.dart';

class NetworkSafeWidget extends StatefulWidget {
  const NetworkSafeWidget({
    required this.child,
    this.alertType = NetworkAlertType.snackbar,
    this.onConnectionRestored,
    this.onConnectionError,
    this.showOnConnectionRestoredWidgets = false,
    this.toastPosition = Position.top,
    this.description,
    this.label,
    this.dismissible = false,
    this.custom,
    super.key,
  }) : assert(alertType == NetworkAlertType.bottomSheet &&
            onConnectionError == null);

  final Widget child;
  final NetworkAlertType alertType;
  final bool showOnConnectionRestoredWidgets;
  final Function(BuildContext)? onConnectionRestored;
  final Function(BuildContext)? onConnectionError;
  final Position toastPosition;
  final String? label;
  final String? description;
  final bool dismissible;
  final Function? custom;

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

            if (widget.alertType == NetworkAlertType.snackbar) {
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
            }
            if (widget.alertType == NetworkAlertType.bottomSheet) {
              showModalBottomSheet(
                context: context,
                isDismissible: widget.dismissible,
                builder: widget.onConnectionError?.call(context),
              );
            }
            if (widget.alertType == NetworkAlertType.toast) {
              CherryToast.error(
                title: const Text('No internet connection'),
                toastPosition: widget.toastPosition,
              ).show(context);
            }
            if (widget.alertType == NetworkAlertType.alert) {
              showNetDialogBox(
                title: widget.label ?? 'No Connection',
                description: widget.description ??
                    'Please check you internet connection.',
                dismissible: widget.dismissible,
                action: const CircularProgressIndicator.adaptive(),
              );
              Future.delayed(const Duration(seconds: 1))
                  .then((value) => Navigator.pop(context));
            }

            if (widget.alertType == NetworkAlertType.custom) {
              widget.custom?.call();
            }
          }
          if (connected &&
              isErrorWidgetVisible &&
              widget.showOnConnectionRestoredWidgets) {
            isErrorWidgetVisible = false;

            if (widget.alertType == NetworkAlertType.snackbar) {
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
            }

            if (widget.alertType == NetworkAlertType.toast) {
              CherryToast.success(
                title: const Text('Connection Restored!!'),
                toastPosition: widget.toastPosition,
              ).show(context);
            }

            if (widget.alertType == NetworkAlertType.bottomSheet) {
              showModalBottomSheet(
                context: context,
                isDismissible: widget.dismissible,
                builder: widget.onConnectionRestored?.call(context),
              );
            }
            if (widget.alertType == NetworkAlertType.alert) {
              showNetDialogBox(
                title: widget.label ?? 'Connection',
                description: widget.description ??
                    'Internet Connection Restored successfully.',
                dismissible: widget.dismissible,
                action: const Icon(Icons.done),
              );
              Future.delayed(const Duration(seconds: 1))
                  .then((value) => Navigator.pop(context));
            }
            if (widget.alertType == NetworkAlertType.custom) {
              widget.custom?.call();
            }
          }
          return widget.child;
        });
  }

  showNetDialogBox({
    required String title,
    required String description,
    required bool dismissible,
    required Widget action,
  }) =>
      showCupertinoDialog<String>(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[action],
        ),
      );
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
