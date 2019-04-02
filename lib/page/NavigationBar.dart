part of garage_sale;
class NavigationBar extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Browse'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Orders')
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile')
        )
      ],
    );
  }
}