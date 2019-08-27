import 'package:flutter/material.dart';
import 'package:flutter_devfest/agenda/agenda_page.dart';
import 'package:flutter_devfest/config/index.dart';
import 'package:flutter_devfest/faq/faq_page.dart';
import 'package:flutter_devfest/login/LoginPage.dart';
import 'package:flutter_devfest/map/map_page.dart';
import 'package:flutter_devfest/speakers/speaker_page.dart';
import 'package:flutter_devfest/sponsors/sponsor_page.dart';
import 'package:flutter_devfest/team/team_page.dart';
import 'package:flutter_devfest/universal/image_card.dart';
import 'package:flutter_devfest/utils/devfest.dart';
import 'package:flutter_devfest/utils/tools.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class HomeFront extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var twitterLogin = new TwitterLogin(
    consumerKey: 'k8n2hJMd1rYj8Xt0Sq1JdgMZa',
    consumerSecret: '5kHYsJ6XoHmpG37kA4pg1HY0xGHnpaeX6NjqvL1Rt3TV46uTW3',
  );

  List<Widget> devFestTexts(context) => [
        Text(
          Devfest.welcomeText,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          Devfest.descText,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ];

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget actions(context) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        children: <Widget>[
          SignInButton(
            Buttons.Facebook,
            mini: true,
            onPressed: () {},
          ),
//          RaisedButton(
//            child: Text("Speakers"),
//            shape: StadiumBorder(),
//            color: Colors.green,
//            colorBrightness: Brightness.dark,
//            onPressed: () =>
//                Navigator.pushNamed(context, SpeakerPage.routeName),
//          ),
//          RaisedButton(
//            child: Text("Sponsors"),
//            shape: StadiumBorder(),
//            color: Colors.orange,
//            colorBrightness: Brightness.dark,
//            onPressed: () =>
//                Navigator.pushNamed(context, SponsorPage.routeName),
//          ),
//          RaisedButton(
//            child: Text("Team"),
//            shape: StadiumBorder(),
//            color: Colors.purple,
//            colorBrightness: Brightness.dark,
//            onPressed: () => Navigator.pushNamed(context, TeamPage.routeName),
//          ),
//          RaisedButton(
//            child: Text("FAQ"),
//            shape: StadiumBorder(),
//            color: Colors.brown,
//            colorBrightness: Brightness.dark,
//            onPressed: () => Navigator.pushNamed(context, FaqPage.routeName),
//          ),
//          RaisedButton(
//            child: Text("Locate Us"),
//            shape: StadiumBorder(),
//            color: Colors.blue,
//            colorBrightness: Brightness.dark,
//            onPressed: () => Navigator.pushNamed(context, MapPage.routeName),
//          ),
        ],
      );

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
          ),
          SignInButton(
            Buttons.Email,
            mini: false,
            onPressed: ()
            {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LoginPage()),
              );

            },
          )
        ],
      );

  Widget socialActions(context) => FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.facebookF),
              onPressed: () async {
                await _launchURL("https://facebook.com/imthepk");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.twitter),
              onPressed: () async {
                await _launchURL("https://twitter.com/imthepk");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.linkedinIn),
              onPressed: () async {
                _launchURL("https://linkedin.com/in/imthepk");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.youtube),
              onPressed: () async {
                await _launchURL("https://youtube.com/mtechviral");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.meetup),
              onPressed: () async {
                await _launchURL("https://meetup.com/");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.envelope),
              onPressed: () async {
                var emailUrl =
                    '''mailto:mtechviral@gmail.com?subject=Support Needed For DevFest App&body={Name: Pawan Kumar},Email: pawan221b@gmail.com}''';
                var out = Uri.encodeFull(emailUrl);
                await _launchURL(out);
              },
            ),
          ],
        ),
      );

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
    return user;
  }

  String _userEmail;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _signInWithEmailAndLink() async {
    _userEmail = _emailController.text;

    return await _auth.sendSignInWithEmailLink(
      email: _userEmail,
      url: '<Url with domain from your Firebase project>',
      handleCodeInApp: true,
      iOSBundleID: 'io.flutter.plugins.firebaseAuthExample',
      androidPackageName: 'io.flutter.plugins.firebaseauthexample',
      androidInstallIfNotAvailable: true,
      androidMinimumVersion: "1",
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageCard(
              img: ConfigBloc().darkModeOn
                  ? Devfest.banner_dark
                  : Devfest.banner_light,
            ),
            SizedBox(
              height: 20,
            ),
            ...devFestTexts(context),
            SizedBox(
              height: 20,
            ),
            newActions(context),

//            socialActions(context),
            SizedBox(
              height: 10,
            ),
            Text(
              Devfest.app_version,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  void _signInWithTwitter() async {


    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: result.session.token,
            authTokenSecret: result.session.secret);
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        break;
    }



  }


}




class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;
  final Color color;

  const ActionCard({Key key, this.onPressed, this.icon, this.title, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Ink(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: ConfigBloc().darkModeOn
              ? Tools.hexToColor("#1f2124")
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: !ConfigBloc().darkModeOn
              ? [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
