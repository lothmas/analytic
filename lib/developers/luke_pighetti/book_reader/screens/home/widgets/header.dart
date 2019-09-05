import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../bloc.dart';

const assetsPath = "assets/developers/luke_pighetti/book_reader";

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      lowerBound: 0.37,
      upperBound: 1.0,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of(context).hasOnboarded.listen((hasOnboarded) {
      if (hasOnboarded)
        _controller.reverse();
      else
        _controller.forward();
    });

    final mainContainer = Container(
      alignment: Alignment.topCenter,
      child: SizeTransition(
        sizeFactor: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _Icon(),
            Text(
              "CHALLENGE",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 36.0),
            _Button(),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Stack(
        children: <Widget>[
          mainContainer,
          BackButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Icon extends StatefulWidget {
  @override
  __IconState createState() => __IconState();
}

class __IconState extends State<_Icon> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      lowerBound: 0.6,
      upperBound: 1.0,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    bloc.hasOnboarded.listen((hasOnboarded) {
      if (hasOnboarded)
        _controller.reverse();
      else
        _controller.forward();
    });

    return ScaleTransition(
      alignment: Alignment.bottomCenter,
      scale: _animation,
      child: Container(
        padding: EdgeInsets.only(bottom: 36.0),
        child: Image.asset(
          "$assetsPath/logo.png",
          width: 90.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Button extends StatefulWidget {
  @override
  __ButtonState createState() => __ButtonState();
}

class __ButtonState extends State<_Button> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var twitterLogin = new TwitterLogin(
    consumerKey: 'k8n2hJMd1rYj8Xt0Sq1JdgMZa',
    consumerSecret: '5kHYsJ6XoHmpG37kA4pg1HY0xGHnpaeX6NjqvL1Rt3TV46uTW3',
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    bloc.hasOnboarded.listen((hasOnboarded) {
      if (hasOnboarded)
        _controller.reverse();
      else
        _controller.forward();
    });

    return FadeTransition(
      opacity: _animation,
      child: Center(
        child: newActions(context)
      ),
    );
  }

  Widget newActions(context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: 1.0,
    runSpacing: 1.0,
    children: <Widget>[
      SignInButton(
        Buttons.Facebook,
        mini: false,
        onPressed: () async {

          final facebookLogin = FacebookLogin();
          final result =
          await facebookLogin.logInWithReadPermissions(['email']);

          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              final AuthCredential credential =
              FacebookAuthProvider.getCredential(
                  accessToken: result.accessToken.token);
              final FirebaseUser user =
                  (await _auth.signInWithCredential(credential)).user;
              print("facebook loggedin:: " + result.accessToken.userId);
              final bloc = BlocProvider.of(context);
              bloc.onboarded(true);
              break;
            case FacebookLoginStatus.cancelledByUser:
//                  _showCancelledMessage();
              break;
            case FacebookLoginStatus.error:
//                  _showErrorOnUI(result.errorMessage);
              break;
          }
        },
      ),
      SignInButton(Buttons.Google, mini: false, onPressed: () {
        _handleSignIn();
      }),
      SignInButton(
        Buttons.Twitter,
        mini: false,
        onPressed: ()  {
          _signInWithTwitter();
        },
      )
//          SignInButton(
//            Buttons.Email,
//            mini: false,
//            onPressed: ()
//            {
//              Navigator.pushReplacement(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => new LoginPage()),
//              );
//
//            },
//          )
    ],
  );


  void _signInWithTwitter() async {


    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: result.session.token,
            authTokenSecret: result.session.secret);
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        final bloc = BlocProvider.of(context);
        bloc.onboarded(true);
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        break;
    }



  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    final bloc = BlocProvider.of(context);
    bloc.onboarded(true);
    return user;
  }
  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(18),
      icon: Icon(Icons.arrow_back_ios),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
