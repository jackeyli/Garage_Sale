part of garage_sale;

class _PostItemImage {
  _Image detailImage;
  _Image thumbNailImage;
  _PostItemImage({this.detailImage,this.thumbNailImage});
  static Future<_PostItemImage> fromMap(Map<String,dynamic> map) async{
    _Image detailImage = _Image.fromMap(Map<String,dynamic>.from(map['detailImage']));
    _Image thumbNailImage = _Image.fromMap(Map<String,dynamic>.from(map['thumbNailImage']));
    if(thumbNailImage.imageUrl == null){
      try {
        thumbNailImage.imageUrl = await FirebaseStorage.instance.ref()
            .child(thumbNailImage.imagePath).getDownloadURL();
      }catch(e){

      }
    }
    return _PostItemImage(
      detailImage:detailImage,
      thumbNailImage:thumbNailImage
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'detailImage':this.detailImage.toMap(),
      'thumbNailImage':this.thumbNailImage.toMap()
    };
  }
}
class _Image {
  String imageUrl;
  String imagePath;
  Uint8List data;
  int width;
  int height;
  _Image({this.imageUrl,this.data,this.width,this.height,this.imagePath});
  static _Image fromMap(Map<String,dynamic> map){
    return _Image(
      imageUrl:map['imageUrl'],
      data:Uint8List.fromList([]),
      width:map['width'],
      height:map['height'],
      imagePath: map['imagePath']
    );
  }
  static _Image fromFile(File file){
    List<int> fileData = file.readAsBytesSync();
    dartImage.Image _img = dartImage.decodeImage(fileData);
    return _Image(width:_img.width,height:_img.height,data:Uint8List.fromList(fileData));
  }
  Map<String,dynamic> toMap(){
    return {
      'imageUrl':this.imageUrl,
      'width':this.width,
      'height':this.height,
      'imagePath':this.imagePath
    };
  }
}

