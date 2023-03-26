import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}
class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
  static const Color forget = Color(0xFFAFB8BB);
  static const Color error = Color(0xFFFF004F);
}

class _SignupState extends State<Signup> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? _errorMessage;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return const HomePage();
      } else {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/signbackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 102.0,
              ),
              Text('Inscription',
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
                'Veuillez saisir ces différentes informations,\n afin que vos listes soient sauvegardées.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.27,
                  fontFamily: 'ProximaNova',
                  height: 1.18,

                ),),
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.24,
                      color: Colors.white,
                      fontFamily: 'ProximaNova',
                    ),

                    decoration: InputDecoration(
                      hintText: "Nom d'utilisateur",

                      hintStyle: TextStyle(
                          color: Colors.white, fontSize: 15.24),
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

                      hintStyle: TextStyle(
                          color: Colors.white, fontSize: 15.24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  height: 46.97,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.searchColor,
                      border: Border.all(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 22.44),
                    child: TextField(
                      controller: passwordController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.24,
                        color: Colors.white,
                        fontFamily: 'ProximaNova',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: 15.24),
                        suffixIcon: SvgPicture.asset(
                          'assets/vector_drawables/warning.svg',
                          // Chemin de votre fichier SVG
                          height: 4.0,
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 80),
              Stack(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Firebase.initializeApp();
                      try {
                        final signInMethods =
                        await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);
                        if (signInMethods.isNotEmpty) {
                          // L'adresse e-mail est déjà associée à un compte Firebase
                          setState(() {
                            isLoading = false;
                            _errorMessage = 'Cet e-mail est déjà utilisé.';
                          });
                        } else {
                          // L'adresse e-mail n'est pas utilisée
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (error) {
                        setState(() {
                          isLoading = false;
                          if (error is FirebaseAuthException) {
                            // Utilisez error.code et error.message pour accéder aux informations d'erreur Firebase
                            _errorMessage = 'Erreur : Cet email est déjà utilisé';
                          } else {
                            _errorMessage = error.toString();
                          }
                        });
                      }

                    },
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontSize: 15.24,
                        color: Colors.white,
                        fontFamily: 'ProximaNova',
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 147, vertical: 18),
                      minimumSize: Size(300, 30),
                    ),
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: AppColors.error),
                    ),
                  if (isLoading) Positioned.fill(child: Center(child: CircularProgressIndicator())),
                ],
              ),


              const SizedBox(height: 15),




            ],
          ),
        );
      }
    }
    ),
    );

  }
}
