// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:math';
import 'package:hotcol/Screens/admin_home.dart';
import 'package:hotcol/Screens/barista.dart';
import 'package:hotcol/Screens/cashier_home.dart';
import 'package:hotcol/Screens/chef.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotcol/utils/responsive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String UserName = "";
  String Password = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String loginMutation = """
  mutation Login(\$UserName: String!, \$Password: String!) {
   Login(UserName: \$UserName, Password: \$Password) {
    token
    user {
    id
    UserName
    Role
    HotelName
    LogoUrl
    }
   }
  }
""";

  Future<void> _storeToken(String token, String Role, String HotelName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', Role);
    await prefs.setString('hotel_name', HotelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.loginscaffold,
      body: LayoutBuilder(builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final imageWidth = Responsive.imageSizeFor(context, max: 300);
        final formWidth = min(420.0, constraints.maxWidth * 0.45);

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context, desktop: 24, tablet: 24, mobile: 16).horizontal / 2),
            child: isNarrow
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(image: Image.asset("assets/images/signin.jpg").image, height: imageWidth * 0.9, width: imageWidth * 0.6, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 16),
                      _buildForm(formWidth),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                        child: Image(image: Image.asset("assets/images/signin.jpg").image, height: imageWidth, width: imageWidth * 0.7, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      _buildForm(formWidth),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildForm(double formWidth) {
    return Container(
      width: formWidth,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(color: Apptheme.containerlogin, borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Mutation(
        options: MutationOptions(
          document: gql(loginMutation),
          onCompleted: (dynamic resultData) async {
            if (resultData != null && resultData['Login'] != null) {
              final token = resultData['Login']['token'];
              final user = resultData['Login']['user'];
              final Role = user['Role'];
              final HotelName = user['HotelName'];
              final Logo = user['LogoUrl'] ?? '';

              await _storeToken(token, Role, HotelName);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  if (Role == 'Admin') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome(HotelName: HotelName, Logo: Logo)));
                  } else if (Role == 'Kitchen') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chef(HotelName: HotelName, Logo: Logo)));
                  } else if (Role == 'Cashier') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CashierHome(HotelName: HotelName, Logo: Logo)));
                  } else if (Role == 'Barista') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Barista(HotelName: HotelName, Logo: Logo)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Role not recognized")));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Navigation error: $e")));
                }
              });
            }
          },
          onError: (error) {
            String errorMessage;
            if (error?.linkException != null) {
              errorMessage = "Connection Timeout or Network Error. Please try again.";
            } else if (error!.graphqlErrors.isNotEmpty) {
              if (error.graphqlErrors.first.message.contains("User.Password") && Password.isNotEmpty) {
                return;
              }
              errorMessage = "Login failed: ${error.graphqlErrors.first.message}";
            } else {
              errorMessage = "Login failed due to an unknown error.";
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red, duration: const Duration(seconds: 5)));
          },
        ),
        builder: (RunMutation runMutation, QueryResult? result) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("Sign In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "NotoSerif"))),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.only(left: 10), child: Text("Username:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: emailController,
                    onChanged: (value) => setState(() => UserName = value),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: "your username",
                      fillColor: Apptheme.textfieldlogin,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.only(left: 10), child: Text("Password:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (value) => setState(() => Password = value),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: "your password",
                      fillColor: Apptheme.textfieldlogin,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (UserName.isNotEmpty && Password.isNotEmpty) {
                      runMutation({"UserName": UserName, "Password": Password});
                      emailController.clear();
                      passwordController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    backgroundColor: MaterialStateProperty.all(Apptheme.buttonbglogin),
                  ),
                  child: (result != null && result.isLoading) ? const CircularProgressIndicator(color: Colors.white) : const Text("Login", style: TextStyle(color: Apptheme.buttontxt, fontSize: 18)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}