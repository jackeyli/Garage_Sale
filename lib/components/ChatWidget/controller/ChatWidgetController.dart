part of garage_sale;

class ChatWidgetState {
  final Chat chat;
  ChatWidgetState({this.chat});
}

class ChatWidgetController {
  ChatWidgetState _state = null;
  ChatWidgetController(Chat chat){
    _state = ChatWidgetState(chat:chat);
  }
  StreamController<ChatWidgetState> _streamCtrl = StreamController<ChatWidgetState>();
  void dispose(){
    _streamCtrl.close();
  }
  Future<bool> replyTo(String replyTo,String content) async{
    Chat nChat = Chat(
        replyTo: replyTo,
        postUser:_appRuntimeInfo.currentUser,
        postedDate: DateTime.now(),
        content:content);
    _state.chat.subChats.add(nChat);
    ChatDao.saveChat(_state.chat);
    sync();
    return true;
  }
  void sync() {
    _streamCtrl.add(_state);
  }
}

