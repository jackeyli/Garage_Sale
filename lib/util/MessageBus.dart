part of garage_sale;
class MessageTopics{
  static final String RefreshPostItemList = "REFRESH_POSTITEM_LIST";
  static final String OpenEditing = "OPEN_EDITING";
}

class MessageBus {
  Map<String,List<Function>> listeners = {};
  void subscribe(String topic,Function func) {
    if(!listeners.containsKey(topic)){
      listeners[topic] = [];
    }
    if(listeners[topic].indexOf(func) < 0) {
      listeners[topic].add(func);
    }
  }
  void unsubscribe(String topic,Function func) {
    if(!listeners.containsKey(topic)){
      listeners[topic] = [];
    }
    if(listeners[topic].indexOf(func) >= 0) {
      listeners[topic].remove(func);
    }
  }
  void publish(String topic,CommandMessage message){
    if(listeners.containsKey(topic)) {
      for(Function func in listeners[topic]) {
        Function.apply(func,[message]);
      }
    }
  }
}