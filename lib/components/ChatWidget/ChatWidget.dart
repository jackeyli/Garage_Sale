part of garage_sale;
class ChatWidget extends StatefulWidget{
  final Chat  chat;
  ChatWidget({this.chat});
  @override
  State createState() => _ChatWidgetState(ChatWidgetController(chat));
}

class _ChatWidgetState extends State<ChatWidget> {
  ChatWidgetController _controller;
  _ChatWidgetState(ChatWidgetController controller){
    _controller = controller;
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  Widget _createChatWidget(Chat chat){
    return Card(
      color: Colors.blueGrey[50],
      child:Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width:28,
                height:28,
                padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                child:ClipOval(
                    child:FittedBox(
                        fit:BoxFit.fill,
                        child:chat.postUser.iconUrl == null ?
                        Image.asset("assets/images/defaultPhoto.png")
                            :Image.network(chat.postUser.iconUrl)
                    ))),
            Text(chat.postUser.name,style:TextStyle(
                fontSize: 8,
                color:Colors.grey
            ))
          ],
        ),
        Flexible(
            flex:1,
            child:Container(
                padding:const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Reply to ${chat.replyTo} :',style:TextStyle(
                        fontSize: 10
                    )),
                    SizedBox(width:10,height:8),
                    Text(chat.content,style:TextStyle(
                        fontSize: 12
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child:MaterialButton(
                          color:Colors.blueGrey,
                          child: Text("Reply",
                              style:TextStyle(
                                  fontSize:8,
                                  color: Colors.white
                              )),
                          padding:const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                          minWidth: 10,
                          height:14,
                          onPressed:(){
                            _msgBus.publish(MessageTopics.OpenEditing,CommandMessage(
                                params: {
                                  "callback":(value){
                                    _controller.replyTo(chat.postUser.name, value);
                                  }
                                }
                            ));
                          }
                      ),
                    )
                  ],
                )
            )
        )
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:_controller._streamCtrl.stream,
        initialData: _controller._state,
        builder:(context,snapshot){
          ChatWidgetState _state = snapshot.data;
          return Card(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width:38,
                              height:38,
                              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                              child:ClipOval(
                                  child:FittedBox(
                                      fit:BoxFit.fill,
                                      child:_state.chat.postUser.iconUrl == null ?
                                      Image.asset("assets/images/defaultPhoto.png")
                                          :Image.network(_state.chat.postUser.iconUrl)
                                  ))),
                          Text(_state.chat.postUser.name,style:TextStyle(
                              fontSize: 10,
                              color:Colors.grey
                          ))
                        ],
                      ),
                      Flexible(
                          flex:1,
                          child:Container(
                              padding:const EdgeInsets.symmetric(horizontal: 2.0),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding:const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ConstrainedBox(
                                              constraints:BoxConstraints(minHeight: 50),
                                              child:
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child:Text(_state.chat.content,style:TextStyle(
                                                      fontSize: 12
                                                  )))),
                                        ],
                                      )),
                                ],
                              )
                          )
                      )
                    ],
                  ),
                  Align(
                    alignment:Alignment.centerLeft,
                      child:MaterialButton(
                      padding:const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                      color:Colors.blueGrey,
                      minWidth: 10,
                      height:16,
                      child: Text("Reply",
                          style:TextStyle(
                              fontSize:10,
                              color: Colors.white
                          )),
                      onPressed:(){
                        _msgBus.publish(MessageTopics.OpenEditing,CommandMessage(
                            params: {
                              "callback":(value){
                                _controller.replyTo(_state.chat.postUser.name, value);
                              }
                            }
                        ));
                      }
                  )),
                  _state.chat.subChats.length > 0 ? (
                      Container(
                          padding:const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _state.chat.subChats.map((chat)=>_createChatWidget(chat)).toList(),
                          )
                      )
                  ) : null
                ].where((widget)=>widget != null).toList(),
              ));
        }
    );
  }
}
