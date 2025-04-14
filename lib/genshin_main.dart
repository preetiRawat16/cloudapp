import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popup_card/popup_card.dart';

class genshinMain extends StatefulWidget {
  const genshinMain({super.key});

  @override
  State<genshinMain> createState() => _genshinMainState();
}

class _genshinMainState extends State<genshinMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
            child: Stack(
              children: [
                // Background + Content
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/zzz_back.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Welcome to Genshin Main!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // adjust opacity as needed
                  ),
                ),
                // Floating Icon Button
                Positioned(
                  right: -14,
                  bottom: 1, // Or adjust based on your preference
                  child: PopupItemLauncher(
                    tag: 'post',
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white, // Optional background
                        child: Image.asset(
                          'lib/images/posticon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    popUp: PopUpItem(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      tag: 'test',
                      child: PopUpItemBody(),
                    ),
                  ),

                ),
              ],
            ),
          )


        ],
      ),
    );
  }
}
class PopUpItemBody extends StatelessWidget {
  const PopUpItemBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postTitle = TextEditingController();
    final postDescription = TextEditingController();

    return Center(
      child: Container(
        width: 510,
        height: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Container(
                   width: 220,
                   child: TextField(
                     controller: postTitle,
                    decoration: InputDecoration(
                      hintText: 'Add Title',
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                                   ),
                 ),
                Container(height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFc5daef),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Post '),
                  ),)              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
             TextField(
              controller: postDescription,

              decoration: InputDecoration(
                hintText: 'Please enter text',
                border: InputBorder.none,
              ),
              cursorColor: Colors.white,
              maxLines: 6,
            ),



          ],
        ),
      ),
    );
  }
}