import 'package:flutter/material.dart';
import 'package:flutter_meal_tracker_app/app/features/auth/data/models/sign_in_credentials_model.dart';
import 'package:flutter_meal_tracker_app/app/features/auth/domain/blocs/auth_bloc.dart';
import 'package:flutter_meal_tracker_app/app/features/auth/domain/events/auth_event.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:string_validator/string_validator.dart' as validator;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final form = GlobalKey<FormState>();
  var _obscurePassword = true;
  final authBloc = Modular.get<AuthBloc>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: form,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                validator: (email) {
                  if (email!.isEmpty) {
                    return "Email field is necessary.";
                  }
                  if (!validator.isEmail(email)) {
                    return "Needs to be a valid email.";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Email")),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                obscureText: _obscurePassword,
                validator: (password) {
                  if (password!.isEmpty) {
                    return "Password field is necessary.";
                  }
                  if (password.length < 6) {
                    return "The minimum password length is 6.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  border: const OutlineInputBorder(),
                  label: const Text("Password"),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final isValid = form.currentState!.validate();

                    if (isValid) {
                      authBloc.add(SignInEvent(SignInCredentialsModel(
                          email: emailController.text,
                          password: passwordController.text)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder()),
                  child: const Text("Sign In"),
                ),
              ),
              TextButton(
                  onPressed: () => Modular.to.navigate("/signup"),
                  child: const Text("or Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
