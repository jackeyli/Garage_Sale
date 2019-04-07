part of garage_sale;
class _ImageQuaterTurnDecorator extends _ImageDecorator {
  int quaterTurn;
  _ImageQuaterTurnDecorator(_Image img,Map<String,dynamic> initialParam){
    this.img = img;
    quaterTurn = initialParam['quaterTurn'];
  }
  @override
  Widget decorate(Widget image){
    return RotatedBox(
        quarterTurns:quaterTurn,
        child:image
    );
  }
}
class _ImageActionableDecorator extends _ImageDecorator {
  List<Positioned> actions;
  _ImageActionableDecorator(_Image img,Map<String,dynamic> initialParam){
    this.img = img;
    actions = initialParam['actions'];
  }
  @override
  Widget decorate(Widget image){
    List<Widget> contents = [image];
    contents.addAll(actions);
    return Stack(
      children: contents,
    );
  }
}
class _ImageClickableDecorator extends _ImageDecorator{
  Function callback;
  _ImageClickableDecorator(_Image img,Map<String,dynamic> initialParam){
    this.img = img;
    callback = initialParam['callback'];

  }
  @override
  Widget decorate(Widget image){
    return GestureDetector(
        onTap:(){
          if(this.callback != null)
            Function.apply(this.callback, []);
        },
        child:image
    );
  }
}
abstract class _ImageDecorator {
  _Image img;
  Widget decorate(Widget image) {
      return image;
  }
}
class ImageDecorator {
  final Map<String,dynamic> rotateDecorator;
  final Map<String,dynamic> actionableDecorator;
  final Map<String,dynamic> clickableDecorator;
  final _Image img;
  ImageDecorator({this.img,this.actionableDecorator,this.rotateDecorator,this.clickableDecorator});
  Widget apply(Widget origin){
    Widget result = origin;
    if(this.rotateDecorator != null){
      result = _ImageQuaterTurnDecorator(img,this.rotateDecorator).decorate(result);
    }
    if(this.clickableDecorator != null){
      result = _ImageClickableDecorator(img,this.clickableDecorator).decorate(result);
    }
    if(this.actionableDecorator != null){
      result = _ImageActionableDecorator(img,this.actionableDecorator).decorate(result);
    }
    return result;
  }
}
class ImageWidget extends StatefulWidget {
  final _Image image;
  final ThumbNailSize size;
  final int maxCount = 2;
  final ImageDecorator decorator;
  final loadFromRawData;
  ImageWidget({this.image,this.size = null,this.decorator,this.loadFromRawData = false});
  @override
  State createState() => _ImageWidgetState(image:image,size:size,decorator: decorator,loadFromRawData: loadFromRawData);
}
class _ImageWidgetState extends State<ImageWidget> {
  final _Image image;
  final ThumbNailSize size;
  final int maxCount = 4;
  final loadFromRawData;
  final ImageDecorator decorator;
  _ImageWidgetState({this.image,this.size = null,this.decorator,this.loadFromRawData});
  @override
  void initState(){
    super.initState();
    if(!loadFromRawData) {
      tryFetchImageThumbNail(0).then((success) {
        setState(() {

        });
      });
    }
  }
  Future<bool> tryFetchImageThumbNail(int tryCount) async{
    if(tryCount >= maxCount)
      return true;
    try{
      await image.getThumbNail(size);
      if(!image.thumbNailUrls.containsKey(ThumbNailSizeName[size])) {
        return await Future.delayed(Duration(seconds: 3),
                ()async{
              return await tryFetchImageThumbNail(tryCount + 1);
            });
      } else {
        return true;
      }
    }catch(e){
      return await Future.delayed(Duration(seconds: 3),
              ()async{
            return await tryFetchImageThumbNail(tryCount + 1);
          });
    }
  }
  String _getImageUrl(){
    if(size == null)
      return image.imageUrl;
    else {
      return image.thumbNailUrls[ThumbNailSizeName[size]];
    }
  }
  @override
  Widget build(BuildContext context) {
    String imgUrl = _getImageUrl();
    Widget imageContent = null;
    if(!loadFromRawData){
      if(imgUrl != null) {
        imageContent = CachedNetworkImage(
            placeholder: (context, string) =>
                Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/images/default_image.jpg"))),
            imageUrl: imgUrl
        );
      } else {
        imageContent = Container(
            width:100,
            height:100,
            child:Image.asset("assets/images/default_image.jpg"));
      }
    } else {
      imageContent = FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Image.memory(image.data)
      );
    }
    if(decorator != null){
      imageContent = this.decorator.apply(imageContent);
    }
    return imageContent;
  }
}