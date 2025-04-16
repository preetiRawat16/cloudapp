import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudchat/genshin_main.dart';
import 'package:cloudchat/signup_page.dart';
import 'package:cloudchat/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popup_card/popup_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;


class searchZZZ extends StatefulWidget {
  const searchZZZ({super.key});

  @override
  State<searchZZZ> createState() => _searchZZZState();
}

class _searchZZZState extends State<searchZZZ> {
  List<String> tdTexts = [];
  bool isLoading = true;
  String? selectedCharacter;

  @override
  void initState() {
    super.initState();
    fetchTdData();
  }
  Future<void> fetchTdData() async {
    final url = Uri.parse('https://zenless-zone-zero.fandom.com/wiki/Lighter');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);

      // Find the table with both class names
      final table = document.querySelector('table.wikitable.skill-table');

      if (table != null) {
        final tdElements = table.querySelectorAll('td');

        setState(() {
          tdTexts = tdElements.map((td) => td.text.trim()).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          tdTexts = ['Table not found'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        tdTexts = ['Failed to load page'];
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/zzzback.png'), // your image path
                fit: BoxFit.cover, // or BoxFit.fill, BoxFit.contain, etc.
              ),
            ),
            height: 100,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,15,0),
                    child: Image.asset(
                      'lib/images/zzzlogo.jpg',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Text(
                      "Zenless Zone Zero",
                      style: GoogleFonts.amita(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFd9dadc),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/zzz_back.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child:Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "Lighter";

                              });
                            },
                            child: CardCharacter(name: "Lighter",imgurl: "lib/characters/lighter.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "Lycaon";

                              });
                            },
                            child: CardCharacter(name: "Lycaon",imgurl: "lib/characters/lycaon.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "Harumasa";

                              });
                            },
                            child: CardCharacter(name: "Harumasa",imgurl: "lib/characters/harumasa.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "billy";

                              });
                            },
                            child: CardCharacter(name: "billy",imgurl: "lib/characters/billy.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "anby";

                              });
                            },
                            child: CardCharacter(name: "anby",imgurl: "lib/characters/anby.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "corin";

                              });
                            },
                            child: CardCharacter(name: "corin",imgurl: "lib/characters/corin.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "eve";

                              });
                            },
                            child: CardCharacter(name: "eve",imgurl: "lib/characters/eve.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "miyabi";

                              });
                            },
                            child: CardCharacter(name: "miyabi",imgurl: "lib/characters/miyabi.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "neko";

                              });
                            },
                            child: CardCharacter(name: "neko",imgurl: "lib/characters/neko.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "sebastian";

                              });
                            },
                            child: CardCharacter(name: "sebastian",imgurl: "lib/characters/sebastian.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "seth";

                              });
                            },
                            child: CardCharacter(name: "seth",imgurl: "lib/characters/seth.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "soukaku";

                              });
                            },
                            child: CardCharacter(name: "soukaku",imgurl: "lib/characters/soukaku.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "trigger";

                              });
                            },
                            child: CardCharacter(name: "trigger",imgurl: "lib/characters/trigger.png")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCharacter = "neko";

                              });
                            },
                            child: CardCharacter(name: "neko",imgurl: "lib/characters/neko.png")),


                      ],
                    ),
                  ),
                  if (selectedCharacter == 'Lighter')  CharacterDescription1(name: "Lighter")
                  else if (selectedCharacter == 'Lycaon')  CharacterDescription1(name: "Von_Lycaon")
                  else if (selectedCharacter == 'Harumasa')  CharacterDescription1(name: "Asaba_Harumasa")
                    else if (selectedCharacter == 'billy')  CharacterDescription1(name: "Billy_Kid")
                      else if (selectedCharacter == 'corin')  CharacterDescription1(name: "Corin_Wickes")
                        else if (selectedCharacter == 'eve')  CharacterDescription1(name: "Evelyn_Chevalier")
                          else if (selectedCharacter == 'miyabi')  CharacterDescription1(name: "Hoshimi_Miyabi")
                            else if (selectedCharacter == 'sebastian')  CharacterDescription1(name: "Alexandrina_Sebastiane")
                              else if (selectedCharacter == 'seth')  CharacterDescription1(name: "Seth_Lowell")
                                else if (selectedCharacter == 'soukaku')  CharacterDescription1(name: "Soukaku")
                                  else if (selectedCharacter == 'trigger')  CharacterDescription1(name: "Trigger")
                                    else if (selectedCharacter == 'neko')  CharacterDescription1(name: "Nekomiya_Mana")

                ],

              )

            ),
          )


        ],
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_filled,
                // color: isLikedcolor ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const genshinMain()),
                );

              },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                // color: isLikedcolor ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  userprofile()),
                );
              },
            ),IconButton(
              icon: Icon(
                Icons.find_in_page_rounded,
                // color: isLikedcolor ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  searchZZZ()),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                // color: isLikedcolor ? Colors.red : Colors.grey,
                size: 30,
              ),
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

}


class CardCharacter extends StatelessWidget {
  final String imgurl;
  final String name;


  final ValueNotifier<bool> isLikedNotifier = ValueNotifier(false);
  CardCharacter({required this.name,required this.imgurl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // Set desired width
      height: 120,
      child: Card(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Stack(
          alignment: Alignment.bottomCenter, // ⬅ Aligns child at bottom center
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:  Image.asset(
                this.imgurl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              color: Colors.black54, // Background for text
              child: Text(
                this.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterDescription extends StatefulWidget {
  final String name;

  const CharacterDescription({super.key,required this.name});

  @override
  State<CharacterDescription> createState() => _CharacterDescriptionState();
}

class _CharacterDescriptionState extends State<CharacterDescription> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Text(widget.name),
    );
  }
}


class CharacterDescription1 extends StatefulWidget {
  final String name;
  const CharacterDescription1({super.key,required this.name});

  @override
  State<CharacterDescription1> createState() => _CharacterDescription1State();
}

class _CharacterDescription1State extends State<CharacterDescription1> {
  List<String> tdTexts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTdData();
  }

  @override
  void didUpdateWidget(covariant CharacterDescription1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      fetchTdData(); // Re-fetch data when name changes
    }
  }

  Future<void> fetchTdData() async {
    setState(() {
      isLoading = true;
      tdTexts = [];
    });

    final url = Uri.parse(
        'https://zenless-zone-zero.fandom.com/wiki/${widget.name.replaceAll(' ', '_')}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final table = document.querySelector('table.wikitable.skill-table');

      if (table != null) {
        final tdElements = table.querySelectorAll('td');
        setState(() {
          tdTexts = tdElements.map((td) => td.text.trim()).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          tdTexts = ['Table not found'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        tdTexts = ['Failed to load page'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return tdTexts.length >= 4
        ? SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView(
        child: Card(
          color: const Color(0xff161616),
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(widget.name,
                    style: GoogleFonts.alice(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFb8cc24),
                        letterSpacing: 1,
                      ),
                    )),
                const SizedBox(height: 10),
                Text(
                  tdTexts[3].split('\n\n').first.trim(),
                  style: GoogleFonts.alice(
                    textStyle: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFd9dadc),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        : const Center(child: Text("Not enough data"));
  }
}
