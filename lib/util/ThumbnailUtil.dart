part of garage_sale;

class ThumbnailUtil {
  static File createThumbNail(String thumbNailPath,File origin,int width) {
    dartImage.Image img = dartImage.copyResize(dartImage.decodeImage(origin.readAsBytesSync()), width);
    List<String> fileNames = origin.path.split("/");
    String fileName = (fileNames[fileNames.length - 1]).split("\.")[0];
    File newFile = File(thumbNailPath + fileName + ".jpg");
    newFile.writeAsBytesSync(dartImage.writeJpg(img));
    return newFile;
  }
  static Uint8List createThumbNailDataFromData(List<int> data,int width){
    dartImage.Image img = dartImage.copyResize(dartImage.decodeImage(data), width);
    return Uint8List.fromList(dartImage.writePng(img));
  }
  static Uint8List createThumbNailData(File origin,int width) {
    dartImage.Image img = dartImage.copyResize(dartImage.decodeImage(origin.readAsBytesSync()), width);
    return Uint8List.fromList(dartImage.writePng(img));
  }
}