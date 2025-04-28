import 'package:book_store_app/repository/auth_repo.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Padding smallScreenLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 5
              )
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Login",
                  style: GoogleFonts.playfair(
                      fontSize: 50,
                      color: const Color.fromARGB(255, 10, 25, 51),
                      fontWeight: FontWeight.bold)),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                  ),
                  onPressed: () async {
                    try {
                      final data = await AuthRepo().loginUsers(
                        usernameController.text,
                        passwordController.text,
                      );

                      if (data != null) {
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                      ),
                      onPressed: () async {
                        try {
                          final data = await AuthRepo().loginUsers(
                            usernameController.text,
                            passwordController.text,
                          );

                          if (data != null) {
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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
                    "I'ts a place to find your favorite books",
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
