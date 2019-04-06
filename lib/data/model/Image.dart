part of garage_sale;
enum ThumbNailSize {
  THUMBNAIL_SIZE_100,
  THUMBNAIL_SIZE_200,
  THUMBNAIL_SIZE_400
}
const Map<ThumbNailSize, String> ThumbNailSizeName = {
  ThumbNailSize.THUMBNAIL_SIZE_100: "100",
  ThumbNailSize.THUMBNAIL_SIZE_200: "200",
  ThumbNailSize.THUMBNAIL_SIZE_400: "400"
};
class _Image {
  String imageUrl;
  String imagePath;
  Map<String,String> thumbNailUrls;
  Uint8List data;
  int width;
  int height;
  _Image({this.imageUrl,this.data,this.width,this.height,this.imagePath,this.thumbNailUrls = const {}});
  static _Image fromMap(Map<String,dynamic> map){
    return _Image(
      imageUrl:map['imageUrl'],
      data:Uint8List.fromList([]),
      width:map['width'],
      height:map['height'],
      imagePath: map['imagePath']
    );
  }
  String _getThumbNailPath(String size){
    return '${_appRuntimeInfo.IMG_PATH}/'
        '${_appRuntimeInfo.IMG_THUMBNAIL_PATH}/${size}_${size}/${this.imagePath}';
  }
  Future<String> _getThumbNailUrl(String size) async {
    return await FirebaseStorage.instance.ref().child(_getThumbNailPath(size)).getDownloadURL();
  }
   Future<bool> getThumbNail(ThumbNailSize size) async{
    if(!this.thumbNailUrls.containsKey(ThumbNailSizeName[size])){
      this.thumbNailUrls[ThumbNailSizeName[size]] = await this._getThumbNailUrl(ThumbNailSizeName[size]);
    }
    return true;
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
      'imagePath':this.imagePath,
      'thumbNailUrls':this.thumbNailUrls
    };
  }
}

