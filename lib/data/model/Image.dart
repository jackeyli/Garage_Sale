part of garage_sale;

class _PostItemImage {
  _Image detailImage;
  _Image thumbNailImage;
  _PostItemImage({this.detailImage,this.thumbNailImage});
  static _PostItemImage fromMap(Map<String,dynamic> map){
    return _PostItemImage(
      detailImage:_Image.fromMap(Map<String,dynamic>.from(map['detailImage'])),
      thumbNailImage:_Image.fromMap(Map<String,dynamic>.from(map['thumbNailImage']))
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
  Uint8List data;
  int width;
  int height;
  _Image({this.imageUrl,this.data,this.width,this.height});
  static _Image fromMap(Map<String,dynamic> map){
    return _Image(
      imageUrl:map['imageUrl'],
      data:Uint8List.fromList([]),
      width:map['width'],
      height:map['height']
    );
  }
   _Image createThumbNail(){
   Uint8List data = ThumbnailUtil.createThumbNailDataFromData(this.data, 200);
   return _Image(
     data:data,
     width:this.width,
     height:this.height
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
      'height':this.height
    };
  }
}

