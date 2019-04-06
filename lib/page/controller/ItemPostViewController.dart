part of garage_sale;

class ItemPostViewState {
  PostedItem _item = PostedItem(descriptionImages:[]);
  _Image image = null;
  List<_Image> descriptionImages = [];
  bool isPosting = false;
  _Image currentEditingImage = null;
}

class ItemPostViewController {
  ItemPostViewState _state = ItemPostViewState();
  StreamController<ItemPostViewState> _streamCtrl = StreamController<ItemPostViewState>();
  Future<bool> postItem() async {
    final ref =  PostedItemDao.collectionRef;
    _state.isPosting = true;
    sync();
    _state._item.postedDate = DateTime.now();
    _state._item.seller = _appRuntimeInfo.currentUser;
    await Firestore.instance.runTransaction((Transaction tx) async {
      DocumentReference ref = await PostedItemDao.insert(_state._item, tx);
      if(_state.image != null) {
        _state._item.image = _state.image;
        String downloadUrl = await (await FirebaseStorage.instance.ref().child("${_appRuntimeInfo.IMG_PATH}/ItemImages/descriptions/${ref.documentID}")
            .child("imageUrl").putData(_state._item.image.data).onComplete).ref.getDownloadURL();
        _state._item.image.imageUrl = downloadUrl;
        _state._item.image.imagePath = "ItemImages/descriptions/${ref.documentID}/imageUrl";
      }
      if(_state.descriptionImages.length > 0){
        List<Future<String>> uploadFiles = [];
        for(int i = 0; i < _state.descriptionImages.length;i ++){
          _state._item.descriptionImages.add(_state.descriptionImages[i]);
          uploadFiles.add(new Future<String>(() async{
            return await (await FirebaseStorage.instance.ref().child("${_appRuntimeInfo.IMG_PATH}/ItemImages/descriptions/${ref.documentID}")
                .child("descriptionImages_${i}").putData(_state._item.descriptionImages[i].data).onComplete).ref.getDownloadURL();
          }));
          _state._item.descriptionImages[i].imagePath = "ItemImages/descriptions/${ref.documentID}/descriptionImages_${i}";
        }
        List<String> downloadUrls = await Future.wait(uploadFiles);
        for(int i = 0; i < downloadUrls.length; i ++){
          _state._item.descriptionImages[i].imageUrl = downloadUrls[i];
        }
        await tx.update(ref,<String,dynamic>{'descriptionImages':_state._item.descriptionImages
            .map((img)=>img.toMap()).toList()});
      }
    },timeout:Duration(seconds:120));
    _state.isPosting = false;
    sync();
    return true;
  }
  void updateItemInfo({bool isSync = false,String name,String description,double price,String category}){
    if(name != null)
      _state._item.name = name;
    if(description != null)
      _state._item.description = description;
    if(price != null) {
      _state._item.price = price;
    }
    if(category != null){
      _state._item.category = category;
    }
    if(isSync){
      sync();
    }
  }
  void dispose(){
    _streamCtrl.close();
  }
  void sync() {
    _streamCtrl.add(_state);
  }
  bool deleteImage(_Image image){
    if(image == _state.image){
      if(_state.descriptionImages.length > 0){
        _state.image = _state.descriptionImages[0];
        _state.descriptionImages.removeAt(0);
      } else {
        _state.image = null;
      }
    } else {
      for(int i = 0; i < _state.descriptionImages.length; i ++){
        if(_state.descriptionImages[i] == image){
          _state.descriptionImages.removeAt(i);
          break;
        }
      }
    }
    sync();
  }
  bool setEditingImage(_Image img){
    _state.currentEditingImage = img;
  }
  Future<bool> pickImage(ImageSource source) async{
    if(_state.currentEditingImage == null) {
      if (_state.image == null) {
        _state.image = _Image.fromFile(await ImagePicker.pickImage(source: source));
      } else {
        _state.descriptionImages.add(
            _Image.fromFile(await ImagePicker.pickImage(source: source)));
      }
    } else {
      if(_state.currentEditingImage == _state.image){
        _state.image = _Image.fromFile(await ImagePicker.pickImage(source: source));
      } else {
        for(int i = 0; i < _state.descriptionImages.length; i ++){
          if(_state.descriptionImages[i] == _state.currentEditingImage){
            _state.descriptionImages[i] = _Image.fromFile(await ImagePicker.pickImage(source: source));
            break;
          }
        }
      }
    }
    sync();
  }
}

