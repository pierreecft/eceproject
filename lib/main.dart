import 'package:eceproject/login.dart';
import 'package:eceproject/services/toggle/toggle_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'allez.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleBloc(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const AllezPage();
          }
          else {
            return const LoginsPage();
          }
        }
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A2025),
      ),
    ),
    );
  }
}
