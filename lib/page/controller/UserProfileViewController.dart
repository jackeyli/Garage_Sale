part of garage_sale;

class UserProfileViewState {
  User _user = null;
  File iconImg = null;
  bool isInAmend = false;
}

class UserProfileViewController {
  UserProfileViewState _state = UserProfileViewState();
  StreamController<UserProfileViewState> _streamCtrl = StreamController<UserProfileViewState>();
  UserProfileViewController(){
    _state._user = _appRuntimeInfo.currentUser;
  }
  void updateUserInfo({String name,String email,String phone}){
    if(name != null)
      _state._user.name = name;
    if(email != null)
      _state._user.email = email;
    if(phone != null) {
      _state._user.phone = phone;
    }
  }
  void dispose(){
    _streamCtrl.close();
  }
  void sync() {
    _streamCtrl.add(_state);
  }
  Future<bool> saveUser() async{
    final ref = UserDao.collectionRef;
      final DocumentReference docRef = ref.document(_state._user.id);
      if(_state.iconImg != null){
        _state._user.iconUrl = await (await FirebaseStorage.instance.ref().child("ProfileImages")
         .child(_state._user.id).putFile(_state.iconImg).onComplete).ref.getDownloadURL();
      }
      await docRef.updateData(_state._user.toMap());
      return true;
  }
  void edit(){
    _state.isInAmend = true;
    sync();
  }
  void editComplete(){
    _state.isInAmend = false;
    sync();
  }
  Future<bool> logout() async{
    await signOutWithGoogle();
    return true;
  }
  Future<bool> pickImage() async{
    if(_state.iconImg != null) {
      await _state.iconImg.delete();
    }
    File origin = await ImagePicker.pickImage(source:ImageSource.gallery);
    _state.iconImg = ThumbnailUtil
        .createThumbNail("/storage/emulated/0/garage_sale/thumbnails/", origin,200);
    sync();
  }
}

