import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionLabel extends StatefulWidget {
  const AppVersionLabel({super.key});

  @override
  State<AppVersionLabel> createState() => _AppVersionLabelState();
}

class _AppVersionLabelState extends State<AppVersionLabel> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final info = snapshot.data!;
        return Text(
          'Versión ${info.version} (${info.buildNumber})',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
