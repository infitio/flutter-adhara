typedef void StopPropagation();
typedef void PreventDefault();
typedef void EventHandlerCallback(dynamic data, [String sender, StopPropagation stopPropagation, PreventDefault preventDefault]);

class EventHandler{

  Map<String, Map<String, EventHandlerCallback>> _registeredEvents = {};

  EventHandler();

  register(String tag, String eventName, EventHandlerCallback handler){
    if(_registeredEvents[eventName]==null){
      _registeredEvents[eventName] = {};
    }
    _registeredEvents[eventName][tag] = handler;
  }

  unregister(String tag, [String eventName]){
    if(eventName!=null){
      _registeredEvents[eventName][tag] = null;
    }
    _registeredEvents.forEach((String eventName, Map<String, EventHandlerCallback> tagHandlerMap){
      tagHandlerMap[tag] = null;
    });
  }

  trigger(String eventName, dynamic data, String senderTag){
    bool stopPropagation = false;
    bool preventDefault = false;
    _registeredEvents[eventName].forEach((String tag, EventHandlerCallback handler){
      if(handler==null) return;
      if(!stopPropagation) {
        handler(data, senderTag, () {
          stopPropagation = true;
        }, () {
          preventDefault = true;
        });
      }
    });
    return !preventDefault;
  }

}