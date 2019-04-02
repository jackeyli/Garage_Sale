part of garage_sale;
class MyItemPage extends StatefulWidget {
  @override
  State createState() => new MyItemState();
}
class MyItemState extends State<MyItemPage> {
  //final UserProfileViewController controller = UserProfileViewController();
  final MyItemViewController controller = MyItemViewController();
  @override
  void initState() {
    super.initState();
    _msgBus.publish(MessageTopics.RefreshPostItemList, null);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._state,
        builder:(context,snapshot){
          MyItemViewState _state = snapshot.data;
          Widget content = null;
          if(_state.isLoading) {
            content = Center(child:CircularProgressIndicator());
          } else {
            content = ListView(
              children: _state.postedItems.map((item){
                return GestureDetector(
                    onTap:(){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_)=>ItemDetailPage(itemId:item.id))
                      );
                    },
                    child:ItemWidget(item:item,isAuto:true));
              }).toList(),
            );
          }
          return Scaffold(
              appBar:AppBar(
                title: Center(child:Text('My Items')),
              ),
              body:content
          );
        }
    );
  }
}