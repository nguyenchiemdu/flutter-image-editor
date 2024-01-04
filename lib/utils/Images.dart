import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

const frame1 = 'images/frame/frame1.png';
const frame2 = 'images/frame/frame2.png';
const frame3 = 'images/frame/frame3.png';
const frame4 = 'images/frame/frame4.png';
const frame5 = 'images/frame/frame5.png';
const frame6 = 'images/frame/frame6.png';
const frame7 = 'images/frame/frame7.png';
const frame8 = 'images/frame/frame8.png';
const frame9 = 'images/frame/frame9.png';
const frame10 = 'images/frame/frame10.png';
const frame11 = 'images/frame/frame11.png';
const frame12 = 'images/frame/frame12.png';
const frame13 = 'images/frame/frame13.png';
const frame14 = 'images/frame/frame14.png';
const frame15 = 'images/frame/frame15.png';
const frame16 = 'images/frame/frame16.png';
const frame17 = 'images/frame/frame17.png';
const frame18 = 'images/frame/frame18.png';
const frame19 = 'images/frame/frame19.png';
const frame20 = 'images/frame/frame20.png';
const frame21 = 'images/frame/frame21.png';
const frame22 = 'images/frame/frame22.png';
const frame23 = 'images/frame/frame23.png';
const frame24 = 'images/frame/frame24.png';
const frame25 = 'images/frame/frame25.png';
const frame26 = 'images/frame/frame26.png';
const frame27 = 'images/frame/frame27.png';
const ic_premium = 'images/ic_premium.png';

String wallpaper1 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/1.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper2 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/2.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper3 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/3.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper4 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/4.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper5 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/5.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper6 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/6.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper7 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/7.jpeg?alt=media&token=0a7c1b44-15f1-4319-af5b-c86b879bd333';
String wallpaper11 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/11.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper12 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/12.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper13 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/13.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper14 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/14.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper15 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/15.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper16 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/16.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper17 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/17.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper18 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/18.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper19 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/19.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper20 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/20.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper21 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/21.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper22 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/22.jpg?alt=media&token=39b4d126-e8bb-4b5e-86e9-470ce59d84dc';
String wallpaper23 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/23.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper24 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/24.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper25 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/25.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper26 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/26.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper27 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/27.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper28 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/28.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper29 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/29.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper30 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/30.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper31 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/31.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper32 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/32.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';
String wallpaper33 =
    'https://firebasestorage.googleapis.com/v0/b/photo-editor-2cf30.appspot.com/o/33.jpg?alt=media&token=314e6452-6919-484e-bdd3-d94665413748';

class ImageUtil {
  static Future<Size> calculateImageDimension(File file) {
    Completer<Size> completer = Completer();
    Image image = Image.file(file);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
