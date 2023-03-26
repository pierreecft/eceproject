import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'search.dart';
import 'package:http/http.dart' as http;


class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
  static const Color smoke = Color(0xFF1E262C);
}

class WishlistPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.topLeft,
            child: Text('Mes likes', style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 8.0,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/vector_drawables/empty_whishlist.svg'),
              SizedBox(height: 40),
              Text('Vous n’avez encore pas liké de contenu \n Cliquez sur le coeur pour en rajouter.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),),
            ],
          ),
        )
    );
  }
}
