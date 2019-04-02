part of garage_sale;
class ListViewWidgetItem extends StatefulWidget {
  final ListViewWidgetController controller;
  ListViewWidgetItem({this.controller}){

  }
  @override
  State createState() => _ListViewWidgetState(controller:controller);
}
class _ListViewWidgetState extends State<ListViewWidgetItem> {
  final ListViewWidgetController controller;
  _ListViewWidgetState({this.controller});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._items,
        builder:(context,snapshot){
          List<PostedItem> _list = snapshot.data;
          Widget content = null;
          if(_list.length == 0) {
            content = Container(
                padding:const EdgeInsets.symmetric(horizontal: 8.0),
                child:Column(
                  children: <Widget>[
                    Center(
                        child:Container(
                            width:200,
                            height:200,
                            child:FittedBox(
                              fit:BoxFit.contain,
                              child:Image.asset("assets/images/no_data.jpeg"),
                            )
                        )),
                    Text("No Data")
                  ],
                )
            );
          } else
          {
            List<PostedItem> _listLeft = [];
            List<PostedItem> _listRight = [];
            for (var i = 0; i < _list.length; i ++) {
              if (i % 2 == 0)
                _listLeft.add(_list[i]);
              else
                _listRight.add(_list[i]);
            }
            content = Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                      flex:1,
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _listLeft.length != 0 ? _listLeft.map((item) => 
                              GestureDetector(
                                  onTap:(){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_)=>ItemDetailPage(itemId:item.id))
                                    );
                                  },
                                  child:ItemWidget(item:item)))
                              .toList() : <Widget>[
                            Container()
                          ]
                      )),
                  Flexible(
                      flex:1,
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _listRight.length != 0 ? _listRight.map((item) => GestureDetector(
                              onTap:(){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_)=>ItemDetailPage(itemId:item.id))
                                );
                              },
                              child:ItemWidget(item:item)))
                              .toList() : <Widget>[
                            Container()
                          ]
                      ))
                ]
            );
          }
          return SingleChildScrollView(
              child:content);
        }
    );
  }
}