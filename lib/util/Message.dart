part of garage_sale;

enum CommandType{
  PostItem
}
class CommandMessage {
  CommandType type;
  Map<String,dynamic> params;
  CommandMessage({this.type,this.params = const {}}){

  }
}