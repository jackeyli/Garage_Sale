part of garage_sale;
const POSTEDITEMSTATUS_POSTED = "Posted";
const POSTEDITEMSTATUS_BOOKED = "Booked";
const POSTEDITEMSTATUS_SOLD = "Sold";
class PostedItem{
  double price;
  String name;
  String id;
  String description;
  _Image image = _Image();
  List<_Image> descriptionImages = [];
  String category;
  String status;
  User bookingUser;
  User seller;
  DateTime postedDate;
  PostedItem({this.id,this.name,this.price,this.description,this.image,this.descriptionImages = const []
  ,this.status = POSTEDITEMSTATUS_POSTED,this.seller,this.category = "Phone",this.postedDate,this.bookingUser}) {
  }
  Map<String,dynamic> toMap(){
    return {
      'price':this.price,
      'name':this.name,
      'description':this.description,
      'image': this.image != null ? this.image.toMap() : {},
      'descriptionImages':this.descriptionImages.map((img)=>img.toMap()).toList(),
      'category':this.category,
      'status':this.status,
      'bookingUser':this.bookingUser == null ? null:this.bookingUser.id,
      'seller':this.seller.id,
      'postedDate':this.postedDate
    };
  }
}

class PostedItemDao {
  static final CollectionReference collectionRef = Firestore.instance.collection("PostedItems");
  static Future<PostedItem> _futureFromSnapshot(DocumentSnapshot snapshot) async{
    PostedItem item = PostedItem(
        name:snapshot.data['name'],
        price:snapshot.data['price'],
        image: _Image.fromMap(Map<String,dynamic>.from(snapshot.data['image'])),
        descriptionImages: List<_Image>.from((snapshot.data['descriptionImages'] as List<dynamic>)
            .map((val)=>_Image.fromMap(Map<String,dynamic>.from(val))).toList()),
        description: snapshot.data['description'],
        status:snapshot.data['status'],
        postedDate:(snapshot.data['postedDate'] as Timestamp).toDate(),
        id:snapshot.documentID
    );
    item.seller = await UserDao.findUser(snapshot.data['seller']);
    if(snapshot.data['bookingUser'] != null) {
      item.bookingUser = await UserDao.findUser(snapshot.data['bookingUser']);
    }
    return item;
  }
  static Future<PostedItem> findById(String id) async{
    DocumentReference ref = await collectionRef.document(id);
    DocumentSnapshot snap = await ref.get();
    if(snap == null || !snap.exists) {
      return null;
    } else {
      return await _futureFromSnapshot(snap);
    }
  }
  static Future<List<PostedItem>>getPostedItem(Query q) async{
      QuerySnapshot result = await q.getDocuments();
      List<Future<PostedItem>> futures = result.documents
          .map<Future<PostedItem>>((snapshot) {
        return new Future<PostedItem>(() => _futureFromSnapshot(snapshot));
      }).toList();
      return await Future.wait(futures);
  }
  static Future<List<PostedItem>>searchByCategory(String category,int limit) async{
    if(limit < 0) {
      return getPostedItem(collectionRef.where("category",isEqualTo: category)
          .orderBy("postedDate",descending: true));
    } else {
      return getPostedItem(collectionRef.where("category", isEqualTo: category)
          .orderBy("postedDate", descending: true)
          .limit(limit));
    }
  }
  static Future<List<PostedItem>>searchMyItem() async{
    return getPostedItem(collectionRef
      .where("seller",isEqualTo: _appRuntimeInfo.currentUser.id)
        .orderBy("postedDate",descending: true));
  }
  static Future<DocumentReference> insert(PostedItem item,Transaction tx) async{
    DocumentReference ref = await collectionRef.add({});
    tx.set(ref,item.toMap());
    return ref;
  }
}