part of garage_sale;

class ItemDetailViewState {
  PostedItem _item = PostedItem(descriptionImages:[]);
  List<Chat> _chats = [];
}

class ItemDetailViewController {
  ItemDetailViewState _state = ItemDetailViewState();
  StreamController<ItemDetailViewState> _streamCtrl = StreamController<ItemDetailViewState>();
  Future<bool> loadItemDetail(String id) async{
    _state._item = await PostedItemDao.findById(id);
    _state._chats.clear();
    _state._chats.addAll(await ChatDao.findByPostItem(id));
    sync();
  }
  Future<bool> postChat({String content}) async{
    Chat nChat = Chat(postItemKey: _state._item.id,postUser: _appRuntimeInfo.currentUser,
    content:content);
    await ChatDao.saveChat(nChat);
    _state._chats.insert(0, nChat);
    sync();
  }
  void dispose(){
    _streamCtrl.close();
  }
  void sync() {
    _streamCtrl.add(_state);
  }
}

