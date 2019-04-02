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
}