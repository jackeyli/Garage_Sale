part of garage_sale;
class BrowsePage extends StatefulWidget {
  @override
  State createState() => new _BrowseState();
}
class _BrowseState extends State<BrowsePage> {
  //final UserProfileViewController controller = UserProfileViewController();
  final BrowseItemViewController controller = BrowseItemViewController();
  final _key = GlobalKey<ScaffoldState>();
  ListViewWidgetItem itemWidget = null;
  @override
  void initState() {
    super.initState();
    _msgBus.publish(MessageTopics.RefreshPostItemList, null);
    itemWidget = ListViewWidgetItem(controller:controller.widgetController);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._state,
        builder:(context,snapshot){
          BrowseItemViewState _state = snapshot.data;
          Widget content = Column(
            children: <Widget>[
              SizedBox(width:10,height:10),
              GridView.count(
                shrinkWrap: true,
                crossAxisSpacing: 4,
                crossAxisCount: 4,
                children: _appRuntimeInfo.supportedCategories.map((Map<String,String> map){
                  return FlatButton(
                      color:_state.category == map['value'] ? Colors.grey:Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(_appRuntimeInfo.categoryIcons[map['icon']],color:Colors.blueGrey[200]),
                          SizedBox(height:10,width:10),
                          Text(map['value'],style:TextStyle(color:Colors.grey[400],fontSize:10)),
                        ],
                      ),
                      onPressed:(){
                        controller.searchPostedItemsAndUpdate(map['value']);
                      }
                  );
                }).toList(),
              ),
              Flexible(
                  flex:1,
                  child:_state.isLoading ? Center(child:LoadingSignal(message:'Loading...')):ListViewWidgetItem(controller:controller.widgetController)
              )
            ],
          );
          return Scaffold(
              key:_key,
              appBar:AppBar(
                title: Center(child:Text('Home')),
                actions: <Widget>[
                  FlatButton(
                      textColor: Colors.white,
                      color:Colors.blueGrey[600],
                      child:Text('Post Item',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                      onPressed:(){
                        Navigator.of(context).pushNamed("/PostItem").then((result){
                          if(result != null) {
                            PostedItem item = result;
                            new Future(() async{
                              if(item.category == controller._state.category) {
                                await controller.refreshItemView();
                              }
                              _key.currentState.showSnackBar(SnackBar(
                                  content:Text('You have just posted an item!')
                              ));
                            });
                          }
                        });
                      }
                  )
                ],
              ),
              body:Container(
                  padding:const EdgeInsets.symmetric(horizontal: 4.0),
                  child:content
              )
          );
        }
    );
  }
}