import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisight/features/notifications/notifications_provider.dart';
import 'package:omnisight/firebase_options.dart';
import 'package:omnisight/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: OmniSight(),
    ),
  );
}

class OmniSight extends ConsumerWidget {
  const OmniSight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsProvider);
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'OmniSight',
      theme: ThemeData(
        primaryColor: Color(0xFFF0F0F0),
      ),
    );
  }
}
