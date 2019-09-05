import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_storage/firebase_storage.dart';

import 'bloc.dart';

import 'widgets/background.dart';
import 'widgets/header.dart';
import 'widgets/drawer.dart';
import 'widgets/bookshelf.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        homeBloc: HomeBloc(),
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(logged_in() != null){
      final bloc = BlocProvider.of(context);
      bloc.onboarded(true);
    }else{

    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Background(),
        Header(),
        MyDrawer(),
        Bookshelf(),
      ],
    );
  }
}

Future<bool> logged_in() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:886993795008:ios:d682d7e2aee1bf4a'
          : '1:886993795008:android:d682d7e2aee1bf4a',
//      gcmSenderID: '159623150305',
      apiKey: 'AIzaSyDYE13jkl283raYvE0MfmZfZOVwCsmHd70',
      projectID: 'polls-223422',
    ),
  );
//  final FirebaseStorage storage =
//  FirebaseStorage(app: app, storageBucket: 'gs://polls-223422.appspot.com');
//  String userUID;
  FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    if (user != null) {
      return true;
    }
    else{
      return false;
    }

  });
}
