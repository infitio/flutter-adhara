typedef void StopPropagation();
typedef void PreventDefault();
typedef dynamic EventHandlerCallback(dynamic data, AdharaEvent event);

enum AdharaEventType { CUSTOM, ADHARA, PLATFORM }

class AdharaEvent {
  String sender;
  bool propagate = true;
  bool preventDefaultAction = false;
  Map _data = {};
  AdharaEventType type;

  AdharaEvent({this.sender, this.type: AdharaEventType.CUSTOM});

  stopPropagation() {
    propagate = false;
  }

  preventDefault() {
    preventDefaultAction = true;
  }

  setData(dynamic key, dynamic value) {
    _data[key] = value;
  }

  getData(dynamic key) {
    return _data[key];
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

  Future<AdharaEvent> trigger(
      String eventName, dynamic data, String senderTag) async {
    AdharaEvent _e = AdharaEvent(sender: senderTag);
    List<Future> _futures = [];
    (_registeredEvents[eventName] ?? {})
        .forEach((String tag, EventHandlerCallback handler) {
      if (handler == null) return;
      if (_e.propagate) {
        _futures.add(_eventHandlerWrapper(tag, handler, data, _e));
      }
    });
    await Future.wait(_futures);
    return _e;
  }

  Future _eventHandlerWrapper(String tag, EventHandlerCallback handler,
      dynamic data, AdharaEvent _e) async {
    var r = await handler(data, _e);
    _e.setData(tag, r);
  }
}
