part of garage_sale;
class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  Future onSelectNotification(String payload) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>ItemDetailPage(itemId: payload))
    );
  }
  Future<bool> _showNotification(Map<String,dynamic> message) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        _appRuntimeInfo.NOTIFICATION_CHANNEL_ID, _appRuntimeInfo.NOTIFICATION_CHANNEL_NAME,
        _appRuntimeInfo.NOTIFICATION_CHANNEL_DESCRIPTION,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['notification']['title'], message['notification']['body'], platformChannelSpecifics,
        payload: message['data']['itemId']
    );
  }
  @override
  final List<Widget> pages = [];
  int _pageIndex = 0;
  void initState() {
    super.initState();
    pages.add(BrowsePage());
    pages.add(MyItemPage());
    pages.add(UserProfilePage());
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('\@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap:(index){
          setState((){
            _pageIndex = index;
          });
        },
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              title: Text('Products')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      )
    );
  }
}