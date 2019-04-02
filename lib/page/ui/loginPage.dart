part of garage_sale;
class SplashPage extends StatefulWidget {
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    _auth.onAuthStateChanged
        .firstWhere((user) => user != null)
        .then((user) async{
          User _user = await UserDao.findUser(user.uid);
          if(_user == null) {
            _user = User(name: user.displayName,email:user.email,iconUrl: user.photoUrl);
            await UserDao.createAndUpdateUser(user.uid, _user);
          }
          _appRuntimeInfo.currentUser = _user;
          isLogin = false;
          Navigator.of(context).pushReplacementNamed('/Home');
    });
    // Listen for our auth even (on reload or start)
    // Go to our /todos page once logged in
  }
  bool login() {
    // Give the navigation animations, etc, some time to finish
    new Future.delayed(new Duration(seconds: 1))
        .then((_){
    signInWithGoogle();});
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: !isLogin ? (<Widget>[
              //Image.asset("assets/images/google_icon.png"),
              Center(
                child:Text('Garage Sale')
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    isLogin = true;
                    login();
                  });
                },
                child:Container(
                  constraints: BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 50
                  ),
                  height:30,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/google_icon.png"),
                      Text('Log in with Google')
                    ],
                  )
                ),
              )
            ]) : (<Widget>[
              Center(child:new CircularProgressIndicator()),
      Center(child:new SizedBox(width: 20.0)),
      Center(child:new Text("Please wait5..."))
            ]),
          ),
        ],
      ),
    );
  }
}