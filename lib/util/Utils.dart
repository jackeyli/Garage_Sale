part of garage_sale;
class DateUtils{
  static DateTime transformFirestoreDate(dynamic t){
    if(Platform.isAndroid){
      return (t as Timestamp).toDate();
    } else {
      return t;
    }
  }
}