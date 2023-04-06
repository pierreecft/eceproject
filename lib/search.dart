import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'description.dart';



class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
}

final TextEditingController _searchController = TextEditingController();

class Game {
  final String name;
  final int appId;


  Game({required this.name, required this.appId});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(name: json['name'], appId: json['appid']);
  }
}



class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Game> _games = [];
  bool _isLoading = false;

  Future<void> _searchGames(String query) async {
    _toggleLoading(true);
    final response = await http.get(
        Uri.parse('https://api.steampowered.com/ISteamApps/GetAppList/v2/'));
    final jsonResponse = json.decode(response.body);
    final apps = jsonResponse['applist']['apps'] as List<dynamic>;
    final List<Game> matches = [];
    for (final app in apps) {
      final name = app['name'] as String;
      final appId = app['appid'] as int;
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matches.add(Game(name: name, appId: appId));
      }
    }
    _toggleLoading(false);
    if (matches.isEmpty) {
      // Afficher un message d'erreur
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error 404'),
          content: Text('Aucun jeu correspondant n\'a été trouvé.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _games = matches;
      });
    }
  }



  void _toggleLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: const [
              Text(
                'Recherche',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryColor,

          elevation: 8.0,
        ),

      body: Container(
        color: AppColors.primaryColor,
        child: Column(
            children: [
            const SizedBox(height: 20),
        Container(
          color: AppColors.searchColor,
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) {
              _searchGames(value);
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
        const SizedBox(height: 16),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

          Padding(
          padding:
          EdgeInsets.only(left: 15, bottom: 10, right: 20, top: 30),
          child: Text(
            'Nombre de résultats : ${_games.length}',
            textAlign: TextAlign.left,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w400,
              fontSize: 19,
              color: Colors.white,
              fontFamily: 'Proxima Nova',
            ),
          ),
        ),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
        Expanded(
          child: ListView.builder(
            itemCount: _games.length,
            itemBuilder: (BuildContext context, int index) {
              final game = _games[index];
              return Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/destinybanner.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 90,
                      height: 80,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/destiny.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            padding: EdgeInsets.only(top:20),
                            child:

                            Text(
                              game.name.split(' ').take(6).join(' '),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'Proxima Nova',
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            child:
                            Padding(
                              padding:
                              EdgeInsets.only(top: 3.0, bottom: 6.0),
                              child: Text(
                                "Nom de l'éditeur",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Proxima Nova',
                                ),
                              ),
                            ),
                          ),

                          Text(
                            'Prix : 10,00€',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontFamily: 'Proxima Nova',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DescriptionPage(gameId: game.appId),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 34),
                        child: Text(
                          'En savoir \n plus',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                          AppColors.buttonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
        ],
    ),





      ),

    );
  }
}
