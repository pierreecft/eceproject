
import 'dart:convert';
import 'search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'likes.dart';
import 'whishlist.dart';
import 'description.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
}

class AllezPage extends StatefulWidget {
  const AllezPage({Key? key}) : super(key: key);

  @override
  State<AllezPage> createState() => _AllezPageState();
}

Future<List<int>> fetchAppIds() async {
  final response = await http.get(Uri.parse('https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final ranks = jsonData['response']['ranks'] as List<dynamic>;

    return ranks.map<int>((rank) => rank['appid'] as int).toList();
  } else {
    throw Exception('Failed to load appids');
  }
}

Future<Map<int, String>> fetchAppNames() async {
  final response = await http.get(Uri.parse('https://api.steampowered.com/ISteamApps/GetAppList/v2/'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final apps = jsonData['applist']['apps'] as List<dynamic>;

    return Map.fromEntries(apps.map((app) => MapEntry(app['appid'] as int, app['name'] as String)));
  } else {
    throw Exception('Failed to load app names');
  }
}

Future<Map<String, dynamic>> fetchGameData(int gameId) async {
  final response = await http.get(
      Uri.parse('https://store.steampowered.com/api/appdetails?appids=$gameId')
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final gameData = jsonData["$gameId"]["data"];
    final lightbackground = gameData["background_raw"];
    final price = gameData["price_overview"] != null ? gameData["price_overview"]["final_formatted"] : "Gratuit";
    return {
      "developers": gameData["developers"].join(", "),
      "price": price,
      "background": gameData["background"],
      "lb" : lightbackground,

    };
  } else {
    throw Exception('');
  }
}


class _AllezPageState extends State<AllezPage> {
  late Future<List<int>> _futureAppIds;
  late Future<Map<int, String>> _futureAppNames;

  @override
  void initState() {
    super.initState();
    _futureAppIds = fetchAppIds();
    _futureAppNames = fetchAppNames();
  }

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
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: SvgPicture.asset('assets/vector_drawables/whishlist.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 275),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                color: AppColors.searchColor,
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
                  decoration: InputDecoration(
                    hintText: 'Rechercher un jeu...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20, right: 10, top: 15),
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: AppColors.buttonColor,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
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
                    child: Image.asset(
                      'assets/images/jeu1.png',
                      width: 130,
                      height: 130,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 60,
                    child: Text(
                      'Titan Fall 2\nUltimate Edition',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.79,
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                    left: 12,
                    bottom: 6,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('En savoir plus'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.buttonColor,
                        padding: EdgeInsets.symmetric(horizontal: 34),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 20, right: 20, top: 20),
                  child: Text(
                    'Les meilleures ventes',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<int>>(
          future: _futureAppIds,
          builder: (context, appIdsSnapshot) {
            if (appIdsSnapshot.hasData) {
              final appIds = appIdsSnapshot.data!;
              return FutureBuilder<Map<int, String>>(
                future: _futureAppNames,
                builder: (context, appNamesSnapshot) {
                  if (appNamesSnapshot.hasData) {
                    final appNames = appNamesSnapshot.data!;
                    return ListView.builder(
                      itemCount: appIds.length,
                      itemBuilder: (context, index) {
                        final appIdbis = appIds[index];
                        final appName = appNames[appIdbis] ?? 'Inconnu';
                        return FutureBuilder<Map<String, dynamic>>(
                          future: fetchGameData(appIdbis),
                          builder: (context, gameDataSnapshot) {
                            if (gameDataSnapshot.hasData) {
                              final gameData = gameDataSnapshot.data!;
                              return Container(
                                margin: EdgeInsets.only(left: 15, bottom: 0, right: 15, top: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(gameData['background']),
                                    fit: BoxFit.cover,

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
                                      children: [
                                        Text(
                                          appName.split(' ').take(2).join(' '),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 3.0, bottom: 8.0),
                                          child: Text(
                                            gameData['developers'].split(' ').take(2).join(' '),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Prix : ${gameData['price']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.underline,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(gameId: appIdbis),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 34),
                                        child: Text(
                                          'En savoir \n plus',
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
                            } else if (gameDataSnapshot.hasError) {
                              return Text('Une erreur est survenue : ${gameDataSnapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      },
                    );
                  } else if (appNamesSnapshot.hasError) {
                    return Text('Une erreur est survenue : ${appNamesSnapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else if (appIdsSnapshot.hasError) {
              return Text('Une erreur est survenue : ${appIdsSnapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}