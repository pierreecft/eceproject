import 'package:eceproject/services/toggle/toggle_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signup.dart';

class LoginsPage extends StatefulWidget {
  const LoginsPage({Key? key}) : super(key: key);

  @override
  State<LoginsPage> createState() => _LoginsPageState();
}

class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
  static const Color forget = Color(0xFFAFB8BB);
}

class _LoginsPageState extends State<LoginsPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signbackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 102.0,
                    ),
                    Text(
                      'Bienvenue !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.53,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.bold,
                        height: 1.37,
                      ),
                    ),
                    SizedBox(
                      height: 17.0,
                    ),
                    Text(
                      'Veuillez vous connecter ou\n créer un nouveau compte\n pour utiliser l’application',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.27,
                        fontFamily: 'ProximaNova',
                        height: 1.18,
                      ),
                    ),
                    SizedBox(
                      height: 27.0,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.searchColor,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 22.44),
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.24,
                            color: Colors.white,
                            fontFamily: 'ProximaNova',
                          ),
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 15.24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.searchColor,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 22.44),
                          child: BlocBuilder<ToggleBloc, ToggleState>(
                              builder: (context, state) {
                            return TextField(
                              obscureText: (state as ToggleInitialState).isOn,
                              controller: passwordController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.24,
                                color: Colors.white,
                                fontFamily: 'ProximaNova',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Mot de passe',
                                suffixIcon: IconButton(
                                  icon:
                                      FaIcon((state)
                                              .isOn
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash),
                                  onPressed: () => context
                                      .read<ToggleBloc>()
                                      .add(ToggleSubmitEvent()),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 15.24),
                              ),
                            );
                          })),
                    ),
                    const SizedBox(height: 80),
                    Stack(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            )
                                .then((_) {
                              setState(() {
                                isLoading = false;
                              });
                              // Rediriger vers la page suivante ici
                            }).catchError((error) {
                              setState(() {
                                isLoading = false;
                              });
                              // Afficher un message d'erreur ici
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "L'email ou le mot de passe est incorrect."),
                                ),
                              );
                            });
                          },
                          child: Text('Se connecter'),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 130, vertical: 18),
                            minimumSize: Size(300, 30),
                          ),
                        ),
                        if (isLoading)
                          Positioned.fill(
                              child:
                                  Center(child: CircularProgressIndicator())),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        // FirebaseAuth.instance.createUserWithEmailAndPassword(
                        //     email: emailController.text.trim(),
                        //     password: passwordController.text.trim());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        'Créer un nouveau compte',
                        style: TextStyle(
                          fontSize: 15.24,
                          color: Colors.white,
                          fontFamily: 'ProximaNova',
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 88, vertical: 18),
                        minimumSize: Size(300, 30),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                              color: AppColors.buttonColor, width: 1.0),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 200, bottom: 80),
                        child: Text(
                          'Mot de passe oublié',
                          style: TextStyle(
                            fontSize: 15.24,
                            color: AppColors.forget,
                            fontFamily: 'ProximaNova',
                            decoration: TextDecoration.underline,
                          ),
                        ))
                  ],
                ))));
  }
}
