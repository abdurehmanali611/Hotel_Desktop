// ignore_for_file: use_build_context_synchronously

import 'package:hotcol/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:upgrader/upgrader.dart';

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final Duration timeout;

  CustomHttpClient({required this.timeout});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request).timeout(timeout);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

final Upgrader upgrader = Upgrader(debugDisplayAlways: true, debugLogging: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  upgrader.initialize();
  await Upgrader.clearSavedSettings();
 
  final Duration timeoutDuration = const Duration(seconds: 30);

  final CustomHttpClient httpClientWithTimeout = CustomHttpClient(
    timeout: timeoutDuration,
  );

  final AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null ? 'Bearer $token' : null;
    },
  );

  final HttpLink httpLink = HttpLink(
    'http://localhost:4000/graphql',
    httpClient: httpClientWithTimeout,
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(GraphQLProvider(client: client, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HotCol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(),
    );
  }
}
