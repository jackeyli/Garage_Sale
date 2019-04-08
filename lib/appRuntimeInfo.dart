part of garage_sale;
class AppRuntimeInfo {
  User currentUser = null;
  List<Map<String,String>> supportedCategories = [
  {"icon":"phone_android","value":"Phone"},{"icon":"shopping_basket","value":"Garment"},{"icon":"directions_car","value":"Car"}
  ,{"icon":"mouse","value":"Digitals"}
  ];
  Map<String,IconData> categoryIcons = {
    "phone_android":Icons.phone_android,
    "shopping_basket":Icons.shopping_cart,
    "directions_car":Icons.directions_car,
    "mouse":Icons.mouse
  };
  final String IMG_PATH = 'Images';
  final String IMG_THUMBNAIL_PATH = 'thumbnails';
  final String NOTIFICATION_CHANNEL_ID = "GARAGE_SALE_CHANNEL_ID";
  final String NOTIFICATION_CHANNEL_NAME = "GARAGE_SALE_CHANNEL_NAME";
  final String NOTIFICATION_CHANNEL_DESCRIPTION = "GARAGE_SALE_CHANNEL_DESCRIPTION";
}