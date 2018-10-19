typedef void StopPropagation();
typedef void PreventDefault();
typedef void EventHandlerCallback(dynamic data, AdharaEvent event);

enum AdharaEventType { CUSTOM, ADHARA, PLATFORM }

class AdharaEvent {
  String sender;
  bool propagate = true;
  bool preventDefaultAction = false;
  AdharaEventType type;
  AdharaEvent({this.sender, this.type: AdharaEventType.CUSTOM});

  stopPropagation() {
    propagate = false;
  }

  preventDefault() {
    preventDefaultAction = true;
  }
}

class EventHandler {
  Map<String, Map<String, EventHandlerCallback>> _registeredEvents = {};

  EventHandler();

  register(String tag, String eventName, EventHandlerCallback handler) {
    if (_registeredEvents[eventName] == null) {
      _registeredEvents[eventName] = {};
    }
    _registeredEvents[eventName][tag] = handler;
  }

  unregister(String tag, [String eventName]) {
    if (eventName != null) {
      _registeredEvents[eventName][tag] = null;
    }
    _registeredEvents.forEach(
        (String eventName, Map<String, EventHandlerCallback> tagHandlerMap) {
      tagHandlerMap[tag] = null;
    });
  }

  AdharaEvent trigger(String eventName, dynamic data, String senderTag) {
    AdharaEvent _e = AdharaEvent(sender: senderTag);
    (_registeredEvents[eventName] ?? {})
        .forEach((String tag, EventHandlerCallback handler) {
      if (handler == null) return;
      if (_e.propagate) {
        handler(data, _e);
      }
    });
    return _e;
  }
}
