part of garage_sale;
class Chat {
  String chatId;
  String postItemKey;
  User postUser;
  String replyTo;
  List<Chat> subChats;
  String content;
  DateTime postedDate;
  Chat({this.chatId,this.postItemKey,this.postUser,this.content,this.replyTo,this.subChats,this.postedDate}) {
    if(this.subChats == null)
      this.subChats = [];
  }
  Map<String,dynamic> toMap(){
    return {
      "postItemKey":this.postItemKey,
      "postUser":this.postUser.id,
      "content":this.content,
      "postedDate":this.postedDate,
      "replyTo":this.replyTo,
      "subChats":this.subChats.map((t)=>t.toMap()).toList(),
    };
  }
}
class ChatDao {
  static final collectionRef = Firestore.instance.collection("Chats");
  static Future<Chat> fromMap(Map<String,dynamic> map) async{
    List<Chat> subChats = [];
    subChats.addAll(await Future.wait((map['subChats'])
        .map<Future<Chat>>((map)=>fromMap(Map<String,dynamic>.from(map))).toList()));
    return Chat(
      postItemKey: map['postItemKey'],
      postUser:await UserDao.findUser(map['postUser']),
      replyTo:map['replyTo'],
      subChats:subChats,
      content:map['content'],
      postedDate:map['postedDate']
    );
  }
  static Future<Chat> fromSnapshot(DocumentSnapshot snapshot) async{
    Chat result = await fromMap(snapshot.data);
    result.chatId = snapshot.documentID;
    return result;
  }
  static Future<Chat> findById(String id) async{
    return fromSnapshot(await collectionRef.document(id).get());
  }
  static Future<List<Chat>> findByPostItem(String id) async{
    QuerySnapshot snapshot = await collectionRef
        .where("postItemKey",isEqualTo: id)
        .orderBy("postedDate",descending: true).getDocuments();
    return await Future.wait(snapshot.documents.map((doc)=>fromSnapshot(doc)).toList());
  }
  static Future<String> saveChat(Chat chat) async {
    if(chat.chatId == null) {
      chat.postedDate = DateTime.now();
      Map<String,dynamic> theMap = chat.toMap();
      chat.chatId = (await collectionRef.add(theMap)).documentID;
    } else {
      await collectionRef.document(chat.chatId).updateData(chat.toMap());
    }
    return chat.chatId;
  }
}