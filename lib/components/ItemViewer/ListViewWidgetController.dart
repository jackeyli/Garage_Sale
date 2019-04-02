part of garage_sale;

class ListViewWidgetController {
  final List<PostedItem> _items = [];
  StreamController<List<PostedItem>> _streamCtrl = StreamController<List<PostedItem>>.broadcast();
  void updatePostedItems(List<PostedItem> itms) {
    _items.clear();
    _items.addAll(itms);
    _streamCtrl.add(_items);
  }
}

