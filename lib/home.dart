import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'search.dart';
import 'description.dart';
import 'likes.dart';
import 'whishlist.dart';


class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/vector_drawables/like.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikesPage()),
              );
              // Code à exécuter lors du clic sur l'icône
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: SvgPicture.asset('assets/vector_drawables/whishlist.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    WishlistPage()),
              );// Code à exécuter lors du clic sur l'icône
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: Column(
            children: [

              SizedBox(height: 20),
              Container(
                color: Color(0xFF1E262C),
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (value) {
                    // setState(() {
                    //   _searchQuery = value;
                    // });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un jeu...',
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 20, right: 10, top: 15),
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: AppColors.buttonColor,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/jeu3.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                  right: 0,
                  child: Image.asset('assets/images/jeu1.png',
                    width: 130,
                    height: 130)
              ),
              Positioned(
                left: 12,
                top: 60,
                child: Text('Titan Fall 2\nUltimate Edition',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.79,
                    fontFamily: 'ProximaNova',
                    fontWeight: FontWeight.w500
                  ),
                ),),
              Positioned(
                left: 12,
                top: 106,
                child: Text(
                  "L'espace colonisé par les humains a fini par \nse diviser en deux grandes zones d'influence : \nles mondes du Noyau et la Frontière.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.74,
                    fontFamily: 'ProximaNova',
                  ),
                   // limite le nombre de lignes à 2
                ),
              ),
              Positioned(
                left:12,
                  bottom:6,
                  child: ElevatedButton(
                    onPressed: (){},
                    child: Text('En savoir plus'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 34),

                    ),
                  ),
              ),

            ],
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 0, right: 20, top: 30),
              child: Text(
                'Les meilleures ventes',
                textAlign: TextAlign.left,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
          Column(
            children: [
              Container(
                margin:
                EdgeInsets.only(left: 15, bottom: 0, right: 15, top: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/destinybanner.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), // ajuster l'opacité ici
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/destiny.png',
                      width: 80,
                      height: 80,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Destiny 2',
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(top: 3.0, bottom: 8.0),
                            child: Text(
                              "Nom de l'éditeur",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Prix : 10,00€',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // action à effectuer lorsque le bouton est pressé
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 34),
                        //ajout de la hauteur au-dessus et en-dessous
                        child: Text(
                          'En savoir \n plus',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.buttonColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: 15, bottom: 0, right: 15, top: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/destinybanner.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), // ajuster l'opacité ici
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/destiny.png',
                      width: 80,
                      height: 80,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Destiny 2',
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(top: 3.0, bottom: 8.0),
                            child: Text(
                              'Activision',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Prix : 40.95€',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // action à effectuer lorsque le bouton est pressé
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 34),
                        //ajout de la hauteur au-dessus et en-dessous
                        child: Text(
                          'En savoir \n plus',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.buttonColor),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Créer un nouveau compte'),
              ),
            ],
          ),
        ],

        // mainAxisAlignment: mainAxisAlignment.center,
      ),
    );
  }

}

