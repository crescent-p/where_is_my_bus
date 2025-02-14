import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';

class RequestPermissionPopup extends StatelessWidget {
  final BuildContext context;

  RequestPermissionPopup({required this.context});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconColor: AppPallete.gradient2,
      icon: const Icon(
        Icons.location_on,
        size: 150,
      ),
      title: const Text('Enable Location Access'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppPallete.gradient2),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Location access is required to find nearby buses.',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.settings, color: AppPallete.gradient2),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'App Permissions -> Under Denied -> Location -> Allow while using the app',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.wifi, color: AppPallete.gradient2),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Make sure you have an active internet connection!',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Open Settings',
            style: TextStyle(
              color: AppPallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            // Add your logic to open settings here

            openAppSettings();
          },
        ),
      ],
    );
  }
}

void showRequestPermissionPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RequestPermissionPopup(context: context);
    },
  );
}
