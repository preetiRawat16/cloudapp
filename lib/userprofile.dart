import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudchat/genshin_main.dart';
import 'package:cloudchat/search.dart';
import 'package:cloudchat/signup_page.dart';
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

class userprofile extends StatefulWidget {
  const userprofile({super.key});

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
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
                  width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,

                  decoration:  BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/zzz_back.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('userId', isEqualTo: currentUserEmail) // Filter by logged-in user
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final posts = snapshot.data!.docs;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(posts.length, (index) {
                                final post = posts[index];
                                final data = post.data() as Map<String, dynamic>;
                                final docId = post.id;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PostWidget(
                                    postText: data['title'],
                                    userid: data['userId'],
                                    postDes: data['description'],
                                    imgurl: data['imageUrl'],
                                    num: data['likes'].toString(),iddoc:docId
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      );
                    },
                  )

                ),

                // Floating Icon Button
                Positioned(
                  right: -14,
                  bottom: 30, // Or adjust based on your preference
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
                  MaterialPageRoute(builder: (context) => const userprofile()),
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
                  MaterialPageRoute(builder: (context) => const searchZZZ()),
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
class PopUpItemBody extends StatelessWidget {
   PopUpItemBody({
    Key? key,
  }) : super(key: key);
  final ValueNotifier<File?> _imageNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isUploadingNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _downloadUrlNotifier = ValueNotifier(null);

   Future<void> _pickFromGallery(BuildContext context) async {
     await Permission.photos.request();
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

     if (pickedFile != null) {
       _imageNotifier.value = File(pickedFile.path);
       _downloadUrlNotifier.value = null;
     }
   }



   @override
  Widget build(BuildContext context) {
    final postTitle = TextEditingController();
    final postDescription = TextEditingController();
    final String userId = 'MlTBX9vkG2hSiE25GAIbyFHr1Y63';
    final String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/cloudcomputing-3d496.firebasestorage.app/o/img%2Fzzz_stockimg.jpg?alt=media&token=58d39663-d4ae-43d1-989c-64e804dbf4de';
    Future<void> _uploadPost(BuildContext context) async {
      if (postTitle.text.isEmpty || postDescription.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all text fields')),
        );
        return;
      }

      _isUploadingNotifier.value = true;

      try {
        String imageUrl;

        // Handle image upload or use default
        if (_imageNotifier.value == null) {
          imageUrl = defaultImageUrl; // Use default image
        } else {

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('img/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await storageRef.putFile(_imageNotifier.value!);
          imageUrl = await storageRef.getDownloadURL();
        }

        // Save post data
        await FirebaseFirestore.instance.collection('posts').add({
          'title': postTitle.text,
          'description': postDescription.text,
          'imageUrl': imageUrl,
          'userId': FirebaseAuth.instance.currentUser!.email,
          'createdAt': FieldValue.serverTimestamp(),
          'likes': 0,
          'comments': [],
          'hasCustomImage': _imageNotifier.value != null, // Track if custom image was used
        });

        // Reset form
        postTitle.clear();
        postDescription.clear();
        _imageNotifier.value = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        _isUploadingNotifier.value = false;
      }
    }

    return Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/zzzback.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: 510,
        height: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: postTitle,
                decoration: InputDecoration(
                  hintText: 'Please enter title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white)
                ),
                cursorColor: Colors.white,
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextField(
                controller: postDescription,
                 style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Please enter text',
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
                cursorColor: Colors.white,
                maxLines: 6,
                           ),
             ),
            SizedBox(height: 30,),
            ValueListenableBuilder<File?>(
              valueListenable: _imageNotifier,
              builder: (context, imageFile, _) {
                return GestureDetector(
                  onTap: () {
                    // Your button action
                    _pickFromGallery(context);
                    print('Image button pressed');
                  },
                  child: Container(
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: imageFile != null
                        ? Image.file(imageFile, fit: BoxFit.cover)
                        : Icon(Icons.photo_library, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Gallery picker button


            SizedBox(height: 20),

            Spacer(),


            SizedBox(height: 10,),
            ValueListenableBuilder<bool>(
              valueListenable: _isUploadingNotifier,
              builder: (context, isUploading, _) {
                return GestureDetector(
                  onTap: isUploading ? null : () => _uploadPost(context),
                  child: Container(
                    width: 200,
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/uploadimg.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            )],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30,),


          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String postText;
  final String userid;
  final String postDes;
  final String imgurl;
  final String num;
  final String iddoc;

  bool isLiked = false;
  bool isLikedcolor = false;

  final ValueNotifier<bool> isLikedNotifier = ValueNotifier(false);
  PostWidget({required this.postText, required this.userid,required this.postDes,required this.imgurl,required this.num, required this.iddoc,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,


        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20, // Adjust size as needed
                    backgroundImage: AssetImage('lib/images/pfp.jpg'), // Replace with your image path
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 10,),
                  Text(this.userid.split('@').first,style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(this.postText,style: GoogleFonts.alice(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFd9dadc),
                  letterSpacing: 1,
                ),
              ),),
            ),

            Image.network(
              height: 200,
                width: MediaQuery.of(context).size.width * 0.95,
                this.imgurl
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,top:10),
              child: Text(this.postDes,style: GoogleFonts.geo(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFd9dadc),
                ),
              ),),
            ),
            Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isLikedNotifier,
                  builder: (context, isLiked, _) {
                    return IconButton(
                      icon: Icon(
                        isLikedcolor ? Icons.favorite : Icons.favorite_border,
                        color: isLikedcolor ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () async {
                        final docRef = FirebaseFirestore.instance.collection('posts').doc(this.iddoc); // replace with your doc ID

                        try {
                          final snapshot = await docRef.get();
                          final currentLikes = snapshot.get('likes') ?? 0;

                          await docRef.update({'likes': currentLikes + 1});


                          // Just toggle the icon (doesn't persist across refresh)
                        } catch (e) {
                          print('Error updating likes: $e');
                        }
                      },
                    );
                    //   onPressed: () {
                    //   },
                    // );
                  },
                ),
                Text(this.num,style: GoogleFonts.geo(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFd9dadc),
                  ),
                ),),
              ],
            )

          ],
        ));
  }
}