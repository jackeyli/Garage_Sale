part of garage_sale;
class ViewPicturePage extends StatelessWidget {
  final _Image image;
  ViewPicturePage({this.image});
  @override
  Widget build(BuildContext context) {
    Widget view = null;
    if(image.height > image.width) {
      view = FittedBox(
        fit: BoxFit.contain,
        child:CachedNetworkImage(
            placeholder: (context,string)=>Center(child:CircularProgressIndicator()),
            imageUrl: image.imageUrl)
      );
    } else {
      view = RotatedBox(
        quarterTurns: 1,
        child:FittedBox(
          fit: BoxFit.contain,
          child:CachedNetworkImage(
              placeholder: (context,string)=>Center(child:CircularProgressIndicator()),
              imageUrl: image.imageUrl
          )
      ));
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child:view
          )
        ],
      )
      //CachedNetworkImage(imageUrl: image.imageUrl)
    );
  }
}