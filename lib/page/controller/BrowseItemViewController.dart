part of garage_sale;

class BrowseItemViewState {
  List<PostedItem> postedItems = [];
  String category;
  bool isLoading = true;
  BrowseItemViewState();
}

class BrowseItemViewController {
  BrowseItemViewState _state = BrowseItemViewState();
  StreamController<BrowseItemViewState> _streamCtrl = StreamController<BrowseItemViewState>();
  ListViewWidgetController widgetController = ListViewWidgetController();
  BrowseItemViewController(){
    _state.category = "Phone";
    _msgBus.subscribe(MessageTopics.RefreshPostItemList,(CommandMessage message){
        refreshItemView();
    });
  }
  void dispose(){
    _msgBus.unsubscribeAll(MessageTopics.RefreshPostItemList);
    _streamCtrl.close();
  }
  void updateItemList(){
      widgetController.updatePostedItems(_state.postedItems);
  }
  Future<bool> refreshItemView() async{
    await searchPostedItemsAndUpdate(_state.category);
    return true;
  }
  void sync(){
    updateItemList();
    _streamCtrl.add(_state);
  }
  Future<bool> searchPostedItemsAndUpdate(String category) async{
    _state.category = category;
    _state.isLoading = true;
    _streamCtrl.add(_state);
    List<PostedItem> items = await PostedItemDao.searchByCategory(_state.category, -1);
    _state.postedItems = items;
    _state.isLoading = false;
    sync();
  }
}

