part of garage_sale;
class LoadingSignal extends StatelessWidget {
  final String message;
  LoadingSignal({this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      width:150,
      height:150,
      child:Column(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width:10,height:10),
          Text(message)
        ],
      )
    );
  }
}