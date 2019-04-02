part of garage_sale;

class MyItemViewState {
  List<PostedItem> postedItems = [];
  bool isLoading = true;
  MyItemViewState();
}

class MyItemViewController {
  MyItemViewState _state = MyItemViewState();
  StreamController<MyItemViewState> _streamCtrl = StreamController<MyItemViewState>();
  MyItemViewController(){
    _msgBus.subscribe(MessageTopics.RefreshPostItemList,(CommandMessage message){
      refreshItemView();
    });
  }
  Future<bool> refreshItemView() async{
    await searchPostedItemsAndUpdate();
    return true;
  }
  void sync(){
    _streamCtrl.add(_state);
  }
  Future<bool> searchPostedItemsAndUpdate() async{
    _state.isLoading = true;
    _streamCtrl.add(_state);
    List<PostedItem> items = await PostedItemDao.searchMyItem();
    _state.postedItems = items;
    _state.isLoading = false;
    sync();
  }
}

