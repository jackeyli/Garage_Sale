part of garage_sale;
class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  final List<Widget> pages = [];
  int _pageIndex = 0;
  void initState() {
    super.initState();
    pages.add(BrowsePage());
    pages.add(MyItemPage());
    pages.add(UserProfilePage());
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