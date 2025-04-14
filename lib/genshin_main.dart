import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
   PopUpItemBody({
    Key? key,
  }) : super(key: key);
  final ValueNotifier<File?> _imageNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isUploadingNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _downloadUrlNotifier = ValueNotifier(null);
  final ValueNotifier<double> _uploadProgressNotifier = ValueNotifier(0);

   Future<void> _pickFromGallery(BuildContext context) async {
     await Permission.photos.request();
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

     if (pickedFile != null) {
       _imageNotifier.value = File(pickedFile.path);
       _downloadUrlNotifier.value = null;
     }
   }

   Future<void> _uploadToFirebase(BuildContext context) async {
     if (_imageNotifier.value == null) return;

     _isUploadingNotifier.value = true;

     try {
       final storageRef = FirebaseStorage.instance
           .ref()
           .child('gallery_uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

       await storageRef.putFile(_imageNotifier.value!);
       _downloadUrlNotifier.value = await storageRef.getDownloadURL();

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Image uploaded successfully!')),
       );
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Upload failed: ${e.toString()}')),
       );
     } finally {
       _isUploadingNotifier.value = false;
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
          // Upload selected image
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
          'userId': userId,
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
                return Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : Icon(Icons.photo_library, size: 50, color: Colors.grey),
                );
              },
            ),
            SizedBox(height: 20),

            // Gallery picker button


            SizedBox(height: 20),

            Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: _isUploadingNotifier,
              builder: (context, isUploading, _) {
                return ValueListenableBuilder<File?>(
                  valueListenable: _imageNotifier,
                  builder: (context, imageFile, _) {
                    return GestureDetector(
                      onTap: () {
                        // Your button action
                        _pickFromGallery(context);
                        print('Image button pressed');
                      },
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
                            'Upload image',
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
                );
              },
            ),

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