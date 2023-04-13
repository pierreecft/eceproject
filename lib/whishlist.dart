import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

        body: const GamesWishlisted()
        
        /*Center(
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
        )*/
    );
  }
}

class GamesWishlisted extends StatefulWidget {
  const GamesWishlisted({Key? key}) : super(key: key);

  @override
  _GamesWishlistedList createState() => _GamesWishlistedList();
}

class _GamesWishlistedList extends State<GamesWishlisted> {
  final Stream<QuerySnapshot> _gamesStream =
      FirebaseFirestore.instance.collection('whishlist').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _gamesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['price']),
              textColor: Colors.white,
              
            );
          }).toList(),
        );
      },
    );
  }
}