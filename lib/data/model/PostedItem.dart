part of garage_sale;
class PostedItem{
  double price;
  String name;
  String id;
  String description;
  _Image image = _Image();
  List<_Image> descriptionImages = [];
  String category;
  String status;
  User seller;
  DateTime postedDate;
  PostedItem({this.id,this.name,this.price,this.description,this.image,this.descriptionImages = const []
  ,this.status = "Posted",this.seller,this.category = "Phone",this.postedDate}) {
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
        postedDate:snapshot.data['postedDate'],
        id:snapshot.documentID
    );
    item.seller = await UserDao.findUser(snapshot.data['seller']);
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
    return getPostedItem(collectionRef.where("category",isEqualTo: category)
        .orderBy("postedDate",descending: true)
        .limit(limit));
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