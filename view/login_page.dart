import 'package:book_store_app/provider/auth_provider.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isBigScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: isBigScreen ? bigScreenLogin(context) : smallScreenLogin(context),
    );
  }

  Widget loginForm(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Login",
                style: GoogleFonts.playfair(
                    fontSize: 40,
                    color: const Color.fromARGB(255, 10, 25, 51),
                    fontWeight: FontWeight.bold)),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                ),
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        await authProvider.loginUser(
                          usernameController.text,
                          passwordController.text,
                        );

                        if (authProvider.loginRes.isNotEmpty &&
                            context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else if (authProvider.loginError.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authProvider.loginError),
                            ),
                          );
                        }
                      },
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Small screen (mobile)
  Padding smallScreenLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 5,
              )
            ],
          ),
          child: loginForm(context),
        ),
      ),
    );
  }

  /// 🔹 Big screen (desktop/tablet)
  Row bigScreenLogin(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(child: loginForm(context)),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color.fromARGB(255, 10, 25, 51),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Book Store",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.playfair(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    "It's a place to find your favorite books",
                    style: GoogleFonts.playfair(
                      fontSize: 30,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
