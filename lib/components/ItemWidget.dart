part of garage_sale;
class ItemWidget extends StatelessWidget {
  PostedItem item;
  bool isHorizontal = false;
  bool isRotateImage = false;
  bool isAuto = false;
  User postUser;
  ItemWidget({this.item,this.isHorizontal = false,this.isAuto = false}) {
    if(this.isAuto){
      if(this.item.image.width > this.item.image.height) {
        this.isHorizontal = true;
      } else {
        this.isHorizontal = true;
        this.isRotateImage = true;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget priceWidget = null;
    debugger();
      priceWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical:2.0),
                  child:Text(
                    '\$ ' + item.price.toString(),
                    style:TextStyle(
                        color:Colors.white,
                        fontSize:10
                    ),
                  ),
                  decoration: BoxDecoration (
                    color: Colors.black26,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical:2.0),
                  child:Text(
                    item.status,
                    style:TextStyle(
                        color:Colors.white,
                        fontSize:10
                    ),
                  ),
                  decoration: BoxDecoration (
                    color: Colors.black26,
                  ),
                ))
          ]);
    List<Widget> contents = [
      ImageWidget(
        image:item.image,
        size:ThumbNailSize.THUMBNAIL_SIZE_400,
        decorator: isRotateImage ? ImageDecorator(
          rotateDecorator: {
            'quaterTurn':1
          }
        ):null,
      ),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.name,
                  style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  )),
              Text(item.description,
                  style:TextStyle(
                      fontSize: 10,
                      color:Colors.grey
                  )),
              isHorizontal ? priceWidget : null,
              isHorizontal ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child:Text(item.seller.name,style:TextStyle(fontSize: 10))
              ) : null
            ].where((widget)=>widget != null).toList(),
          )
      ),
      isHorizontal ? null: priceWidget,
      Divider(),
      isHorizontal ? null :Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child:Text(item.seller.name,style:TextStyle(fontSize: 10))
      ),
      SizedBox(width:10,height:10)
    ].where((widget)=>widget != null).toList();
    Widget content = null;
    if(!isHorizontal) {
      content =  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contents,
      );
    } else {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contents,
      );
    }
    return Align(
        alignment: Alignment.topCenter,
        child:Card(
        child: content));
  }
}