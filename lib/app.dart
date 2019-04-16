// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library garage_sale;

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as dartImage;
part 'package:garage_sale/components/LoadingSignal.dart';
part 'package:garage_sale/util/ThumbnailUtil.dart';
part 'package:garage_sale/components/EditBar/EditBar.dart';
part 'package:garage_sale/components/ItemWidget.dart';
part 'package:garage_sale/components/ImageWidget.dart';
part 'package:garage_sale/components/ChatWidget/ChatWidget.dart';
part 'package:garage_sale/components/ChatWidget/controller/ChatWidgetController.dart';
part 'package:garage_sale/page/ui/myItemPage.dart';
part 'package:garage_sale/page/ui/viewPicturePage.dart';
part 'package:garage_sale/page/ui/loginPage.dart';
part 'package:garage_sale/page/ui/homePage.dart';
part 'package:garage_sale/page/ui/MapPage.dart';
part 'package:garage_sale/page/NavigationBar.dart';
part 'package:garage_sale/page/ui/browsePage.dart';
part 'package:garage_sale/page/ui/ItemPostPage.dart';
part 'package:garage_sale/page/ui/ItemDetailPage.dart';
part 'package:garage_sale/page/controller/ItemPostViewController.dart';
part 'package:garage_sale/util/authentication.dart';
part 'package:garage_sale/components/ItemViewer/ListViewWidgetItem.dart';
part 'package:garage_sale/components/ItemViewer/ListViewWidgetController.dart';
part 'package:garage_sale/data/model/Image.dart';
part 'package:garage_sale/data/model/User.dart';
part 'package:garage_sale/data/model/Chat.dart';
part 'package:garage_sale/data/model/PostedItem.dart';
part 'package:garage_sale/util/Message.dart';
part 'package:garage_sale/util/MessageBus.dart';
part 'package:garage_sale/util/Utils.dart';
part 'package:garage_sale/appRuntimeInfo.dart';
part 'package:garage_sale/page/controller/MyItemsViewController.dart';
part 'package:garage_sale/page/controller/UserProfileViewController.dart';
part 'package:garage_sale/page/controller/BrowseItemViewController.dart';
part 'package:garage_sale/page/controller/ItemDetailViewController.dart';
part 'package:garage_sale/page/ui/userProfilePage.dart';
AppRuntimeInfo _appRuntimeInfo = AppRuntimeInfo();
MessageBus _msgBus = MessageBus();
//final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void showErrorDialog(BuildContext context,String text){
  showDialog(context: context,
      builder: (_) =>
          SimpleDialog(
              title: Text('Error'),
              children: <Widget>[Center(
                  child:Text(text)
              )
              ]
          ));
}

class GarageSaleApp extends StatefulWidget{
  @override
  State createState() => _GarageSaleAppState();
}
class _GarageSaleAppState extends State<GarageSaleApp> {
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Garage Sale',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Helvetica Neue',
        primarySwatch: Colors.blueGrey,
      ),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/Login': (BuildContext context) => SplashPage(),
        '/Home': (BuildContext context) => HomePage(),
        '/PostItem': (BuildContext context) => ItemPostPage()
      },
    );
  }
}
