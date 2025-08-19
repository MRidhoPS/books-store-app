import 'package:book_store_app/provider/auth_provider.dart';
import 'package:book_store_app/provider/book_provider.dart';
import 'package:book_store_app/provider/chart_provider.dart';
import 'package:book_store_app/provider/transaction_provider.dart';
import 'package:book_store_app/repository/auth_repo.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:book_store_app/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookProvider(bookRepo: BookRepo()),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(bookRepo: BookRepo()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.white,
            scrimColor: Colors.white54,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: canvasColor,
            iconTheme: IconThemeData(color: Colors.white),
          )),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthRepo().checkUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
