part of garage_sale;

class ItemPostViewState {
  PostedItem _item = PostedItem(descriptionImages:[]);
  _PostItemImage image = null;
  List<_PostItemImage> descriptionImages = [];
  bool isLoading = false;
}

class ItemPostViewController {
  ItemPostViewState _state = ItemPostViewState();
  StreamController<ItemPostViewState> _streamCtrl = StreamController<ItemPostViewState>();
  Future<bool> postItem() async {
    final ref =  PostedItemDao.collectionRef;
    _state.isLoading = true;
    sync();
    _state._item.postedDate = DateTime.now();
    _state._item.seller = _appRuntimeInfo.currentUser;
    await Firestore.instance.runTransaction((Transaction tx) async {
      DocumentReference ref = await PostedItemDao.insert(_state._item, tx);
      if(_state.image != null) {
        _state._item.image = _state.image;
        String downloadUrl = await (await FirebaseStorage.instance.ref().child("ItemImages/descriptions/${ref.documentID}")
            .child("imageUrl").putData(_state._item.image.detailImage.data).onComplete).ref.getDownloadURL();
        _state._item.image.detailImage.imageUrl = downloadUrl;
        String downloadUrlForThumbNail = await (await FirebaseStorage.instance.ref().child("ItemImages/descriptions/${ref.documentID}")
            .child("imageThumbNailUrl").putData(_state._item.image.thumbNailImage.data).onComplete).ref.getDownloadURL();
        _state._item.image.thumbNailImage.imageUrl = downloadUrlForThumbNail;
        await tx.update(ref,<String,dynamic>{'image':_state._item.image.toMap()});
      }
      if(_state.descriptionImages.length > 0){
        List<Future<String>> uploadFiles = [];
        List<Future<String>> uploadFilesOfThumbnail = [];
        for(int i = 0; i < _state.descriptionImages.length;i ++){
          _state._item.descriptionImages.add(_state.descriptionImages[i]);
          uploadFiles.add(new Future<String>(() async{
            return await (await FirebaseStorage.instance.ref().child("ItemImages/descriptions/${ref.documentID}")
                .child("descriptionImages_${i}").putData(_state._item.descriptionImages[i].detailImage.data).onComplete).ref.getDownloadURL();

          }));
          uploadFilesOfThumbnail.add(new Future<String>(() async{
            return await (await FirebaseStorage.instance.ref().child("ItemImages/descriptions/thumbnails/${ref.documentID}")
                .child("descriptionImages_${i}").putData(_state._item.descriptionImages[i].thumbNailImage.data).onComplete).ref.getDownloadURL();
          }));
        }
        List<String> downloadUrls = await Future.wait(uploadFiles);
        List<String> downloadUrlsThumb = await Future.wait(uploadFilesOfThumbnail);
        for(int i = 0; i < downloadUrls.length; i ++){
          _state._item.descriptionImages[i].detailImage.imageUrl = downloadUrls[i];
          _state._item.descriptionImages[i].thumbNailImage.imageUrl = downloadUrlsThumb[i];
        }
        await tx.update(ref,<String,dynamic>{'descriptionImages':_state._item.descriptionImages
            .map((img)=>img.toMap()).toList()});
      }
    },timeout:Duration(seconds:120));
    _state.isLoading = false;
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
  Future<bool> pickImage(ImageSource source) async{
    File imageFile = await ImagePicker.pickImage(source: source);
    _Image img = _Image.fromFile(imageFile);
    _Image thumbNail = img.createThumbNail();
    if(_state.image == null) {
      _state.image = _PostItemImage(
        detailImage: img,
        thumbNailImage: thumbNail
      );
    } else {
      _state.descriptionImages.add(_PostItemImage(
          detailImage: img,
          thumbNailImage: thumbNail
      ));
    }
    sync();
  }
}

