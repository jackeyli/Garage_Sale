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
          debugger();
          User _user = await UserDao.findUser(user.uid);
          debugger();
          if(_user == null) {
            _user = User(name: user.displayName,email:user.email,iconUrl: user.photoUrl);
            await UserDao.createAndUpdateUser(user.uid, _user);
          }
          debugger();
          _appRuntimeInfo.currentUser = _user;
          isLogin = false;
          //_firebaseMessaging.subscribeToTopic(_user.id);
          debugger();
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
      body:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: !isLogin ? (<Widget>[
        //Image.asset("assets/images/google_icon.png"),
        Image.asset('assets/images/garage_sale.jpg'),
        SizedBox(height:20,width:10),
        Container(
            width:200,
            child:RaisedButton(
              onPressed: () {
                setState(() {
                  isLogin = true;
                  login();
                });
              },
              color:Colors.blueAccent,
              child:Container(
                  height:50,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/google_icon.png"),
                      SizedBox(width:10,height:10),
                      Text('Login with Google',style:TextStyle(color:Colors.white,
                          fontWeight: FontWeight.w900))
                    ],
                  )
              ),
            )
        )
      ]) : (<Widget>[
        Center(child:LoadingSignal(message: 'Please wait...'))
      ]),
    ),
    );
  }
}