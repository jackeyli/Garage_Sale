part of garage_sale;
class User {
  String id;
  String name;
  String email;
  String phone;
  double star;
  String iconUrl;
  User({this.name,this.email,this.phone,this.star,this.iconUrl,this.id}) {
  }
  Map<String,dynamic> toMap(){
    return {
      "name":this.name,
      "email":this.email,
      "phone":this.phone,
      "star":this.star,
      "iconUrl":this.iconUrl
    };
  }
}

class UserDao {
  static final CollectionReference collectionRef = Firestore.instance.collection("Users");
  static User fromSnapshot(DocumentSnapshot snapshot) {
    return User(name:snapshot.data['name'],
        email:snapshot.data['email'],
        phone:snapshot.data['phone'],
        star:snapshot.data['star'],
        id:snapshot.documentID,
        iconUrl:snapshot.data['iconUrl']);
  }
  static Future<User> findUser(String id) async{
    DocumentReference ref = collectionRef.document(id);
    try{
      DocumentSnapshot snap = await ref.get();
      if(snap == null || !snap.exists) {
        return null;
      } else {
        return fromSnapshot(snap);
      }
    }catch(e){
      debugger();
    }
    return null;
  }
  static Future<bool> createAndUpdateUser(String id,User user) async{
    DocumentReference ref = await collectionRef.document(id);
    ref.setData(user.toMap());
     return true;
  }
}