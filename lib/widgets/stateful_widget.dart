import 'package:adhara/resources/event_handler.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:flutter/material.dart';

typedef void VoidCallbackFn();

///Enhanced version of a StatefulWidget required to work with adhara widgets
abstract class AdharaStatefulWidget extends StatefulWidget {
  /// Initializes [key] for subclasses. as Flutter's StatefulWidget
  const AdharaStatefulWidget({Key key}) : super(key: key);
}

///Enhanced version of a State required to work with adhara widgets
abstract class AdharaState<T extends StatefulWidget> extends State<T> {
  ///[tag] is used for adhara to identify a widget uniquely
  ///This is done as the reflection is not exposed as part of flutter-dart
  String get tag;

  @override
  void initState() {
    super.initState();
    _postInit();
  }

  @override
  void setState(VoidCallbackFn fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Map<String, EventHandlerCallback> get eventHandlers => {};

  _postInit() async {
    await ResInheritedWidget.ofFuture(context);
    // ^ just waiting to load resources, nothing else
    Map<String, EventHandlerCallback> _eh = eventHandlers;
    if (_eh.length > 0) {
      eventHandlers.forEach((eventName, handler) {
        this.on(eventName, handler);
      });
    }
    _callFirstLoad();
  }

  _callFirstLoad() async {
    if (isFirstLoadComplete) {
      _callFetchData();
    } else {
      firstLoad().then((_) {
        r.appState.getScope("widgetInit").setValue(tag, true);
        _callFetchData();
      });
    }
  }

  bool get isFirstLoadComplete =>
      r.appState.getScope("widgetInit").getValue(tag, false);

  _callFetchData() async {
    Resources r = await ResInheritedWidget.ofFuture(context);
    fetchData(r);
  }

  ///firstLoad will e called only once per widget [Type] in lifecycle of the application
  ///
  /// Say WidgetX extends [AdharaState], and WidgetX is used in 2 places
  /// firstLoad will be called only once for 2 places
  firstLoad() async {
    /*Do Nothing*/
  }

  ///fetch data will be called always for each widget
  /// Use this to fetch any data and assign local variables
  fetchData(Resources r) async {
    /*Do Nothing*/
  }

  ///Resources object
  Resources _r;

  ///Resources getter
  Resources get r {
    if (_r == null) {
      _r = ResInheritedWidget.of(context);
    }
    return _r;
  }

  ///Listen to events by providing [eventName], [handler]
  on(String eventName, EventHandlerCallback handler) {
    r.eventHandler.register(tag, eventName, handler);
  }

  ///turn of event listening by providing specific [eventName]
  off([String eventName]) {
    r.eventHandler.unregister(tag, eventName);
  }

  ///Trigger an event by providing [eventName], [data] to be passed to the event
  Future<AdharaEvent> trigger(String eventName, dynamic data) {
    return r.eventHandler.trigger(eventName, data, tag);
  }

  ///turning off all events on dispose
  @protected
  @mustCallSuper
  void dispose() {
    off();
    super.dispose();
  }
}
