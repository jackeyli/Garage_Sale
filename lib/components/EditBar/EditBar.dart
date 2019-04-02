part of garage_sale;

class EditBar extends StatefulWidget{
  final Function callback;
  final Function onEditComplete;
  EditBar({this.callback,this.onEditComplete}) {
  }
  @override
  State createState() => _EditBarState(callback:callback,onEditComplete:onEditComplete);
}

class _EditBarState extends State<EditBar> {
  final Function callback;
  final Function onEditComplete;
  _EditBarState({this.callback,this.onEditComplete});
  String _value = "";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height:50,
        padding:const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
        color: Colors.blueGrey[50],
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex:1,
              child:TextField(
                decoration: InputDecoration(
                  hintText: "Type Something",
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
                onChanged: (value){
                  _value = value;
                },
              ),
            ),
            SizedBox(width:10,height:10),
            RaisedButton(
                color:Colors.blueGrey,
                child: Text("Submit",
                    style:TextStyle(
                        fontSize:12,
                        color: Colors.white
                    )),
                onPressed:(){
                  Function.apply(callback,[_value]);
                  Function.apply(onEditComplete,[]);
                }
            )
          ],
        )
    );
  }
}