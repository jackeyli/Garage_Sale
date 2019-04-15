part of garage_sale;
class ItemDetailPage extends StatefulWidget{
  final String itemId;
  ItemDetailPage({this.itemId});
  @override
  State createState() => _ItemDetailState(itemId:itemId);
}
class _ItemDetailState extends State<ItemDetailPage> {
  final String itemId;
  final ItemDetailViewController controller = ItemDetailViewController();
  PersistentBottomSheetController bottomSheet = null;
  _ItemDetailState({this.itemId}){
  }
  void processOpenEditing(CommandMessage message){
    if(bottomSheet != null){
      bottomSheet.close();
      bottomSheet = null;
    }
    Function callback = message.params['callback'];
    bottomSheet = _scaffoldKey.currentState.showBottomSheet((context){
      return EditBar(callback:callback,
          onEditComplete: (){
            if(bottomSheet != null) {
              bottomSheet.close();
              bottomSheet = null;
            }
          });
    });
  }
  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    _msgBus.unsubscribe(MessageTopics.OpenEditing, this.processOpenEditing);
  }
  @override
  void initState(){
    super.initState();
    _msgBus.subscribe(MessageTopics.OpenEditing,processOpenEditing);
    controller.loadItemDetail(itemId);
  }
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _getImageWidget(BuildContext context,_Image img,ThumbNailSize size) {
    if (img == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
      child:ImageWidget(image:img,
      size:size,
      decorator: ImageDecorator(
         clickableDecorator: {
           'callback':(){
             Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewPicturePage(image: img)));
           }
         }
      ))
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._state,
        builder:(context,snapshot) {
          ItemDetailViewState _state = snapshot.data;
          Widget view = null;
          if(_state._item.id == null) {
            view = Container(
                color: Colors.white,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    Center(child:
                    CircularProgressIndicator()),
                    Text('Loading..')
                  ]
                )
            );
          } else {
            Widget column = null;
            List<_Image > descriptionImages = [];
            descriptionImages.addAll(_state._item.descriptionImages);
            int i = descriptionImages.length - 1;
            if(i < 0)
              i = 0;
            for(;i < 4; i ++) {
              descriptionImages.add(null);
            }
            if(_state._item.image != null) {
              column = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _getImageWidget(context,_state._item.image,null),
                    _state._item.descriptionImages.length > 0 ? GridView.count(
                        shrinkWrap: true,
                        crossAxisSpacing: 4,
                        crossAxisCount: 4,
                        children: <Widget>[
                          _getImageWidget(context,descriptionImages[0],ThumbNailSize.THUMBNAIL_SIZE_100),
                          _getImageWidget(context,descriptionImages[1],ThumbNailSize.THUMBNAIL_SIZE_100),
                          _getImageWidget(context,descriptionImages[2],ThumbNailSize.THUMBNAIL_SIZE_100),
                          _getImageWidget(context,descriptionImages[3],ThumbNailSize.THUMBNAIL_SIZE_100)
                        ]
                    ) : null,
                  ].where((widget)=>widget != null).toList());
            }
            view =  SingleChildScrollView(
                child:Container(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          column,
                          Divider(),
                          Container(
                              padding:const EdgeInsets.symmetric(horizontal: 20),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Text(_state._item.category,
                                        style:TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                    SizedBox(width:10,height:10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical:2.0),
                                      child:Text(
                                        "\$ ${_state._item.price.toString()}",
                                        style:TextStyle(
                                            color:Colors.white,
                                            fontSize:12,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      decoration: BoxDecoration (
                                        color: Colors.black26,
                                      ),
                                    ),
                                    SizedBox(width:10,height:10),
                                    Text(_state._item.description,
                                        style:TextStyle(fontSize:12,color:Colors.grey)),
                                    Divider(),
                                    Text("Seller",style:TextStyle(fontSize:14,color:Colors.black)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.seller.name}",style:TextStyle(fontSize:12,color:Colors.grey)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.seller.email}",style:TextStyle(fontSize:12,color:Colors.grey)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.seller.phone}",style:TextStyle(fontSize:12,color:Colors.grey))])),
                          _state._item.status == POSTEDITEMSTATUS_BOOKED ?
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 20),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width:10,height:10),
                                    Text("Booked by",style:TextStyle(fontSize:14,color:Colors.black)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.bookingUser.name}",style:TextStyle(fontSize:12,color:Colors.grey)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.bookingUser.email}",style:TextStyle(fontSize:12,color:Colors.grey)),
                                    SizedBox(width:10,height:10),
                                    Text("${_state._item.bookingUser.phone}",style:TextStyle(fontSize:12,color:Colors.grey))
                                  ],
                                )
                              ): null,
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:<Widget>[
                                    MaterialButton(
                                        color:Colors.blueGrey,
                                        minWidth: 30,
                                        height:40,
                                        child: Text("Comment",
                                            style:TextStyle(
                                                fontSize:14,
                                                color: Colors.white
                                            )),
                                        onPressed:(){
                                          _msgBus.publish(MessageTopics.OpenEditing,CommandMessage(
                                              params: {
                                                "callback":(value){
                                                  controller.postChat(content:value);
                                                }
                                              }
                                          ));
                                        }
                                    ),
                                    SizedBox(width:20,height:10),
                                    (_state._item.status == POSTEDITEMSTATUS_POSTED)?
                                    MaterialButton(
                                        color:Colors.blue,
                                        minWidth: 30,
                                        height:40,
                                        child: Text("Book",
                                            style:TextStyle(
                                                fontSize:14,
                                                color: Colors.white
                                            )),
                                        onPressed:() async{
                                          try {
                                           await controller.bookItem();
                                          }catch(e) {
                                            showErrorDialog(context, "Unexpected Error happened, please contact support");
                                          }
                                        }
                                    )
                                        :null
                                  ].where((widget)=>widget != null).toList()
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _state._chats.map((chat)=>ChatWidget(chat)).toList(),
                                )
                              ],
                            )
                          ),
                        ].where((widget)=>widget != null).toList()
                    )
                )
            );

          }
          return Scaffold(
              key:_scaffoldKey,
              appBar: AppBar(
                title: Text(_state._item.name == null ? "" : _state._item.name,
                    style:TextStyle(fontSize:14,fontWeight: FontWeight.bold)),
              ),
              body: GestureDetector(
                  onTap:(){
                    if(bottomSheet != null){
                      bottomSheet.close();
                      bottomSheet = null;
                    }
                  },
                  child:view
              )
          );
        });
  }
}