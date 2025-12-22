import 'dart:io';

import 'package:amazon_clone/common/bottomBar/gv_bottom_nav_bar.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/admin_bottom_bar.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Windows & Linux & Mac only – disable image HTTPS certificate checks
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  void getUserData() async {
    final res = await authService.getUser();
    if (!mounted) return;
    if (res != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      final userToken = Provider.of<UserProvider>(
        context,
        listen: false,
      ).user.token;
      if (kDebugMode) {
        print("User Token ==> $userToken");
      }
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.greyBackgroundCOlor,
        colorScheme: ColorScheme.light(primary: GlobalVariables.secondaryColor),
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: context.watch<UserProvider>().user.token.isNotEmpty
          ? context.watch<UserProvider>().user.type == "user"
                ? GvBottomNavBar()
                : AdminBottomBar()
          : AuthScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
