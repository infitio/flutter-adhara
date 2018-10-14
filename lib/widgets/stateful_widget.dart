import 'package:flutter/material.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/event_handler.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/resources/r.dart';

typedef void VoidCallbackFn();

abstract class AdharaStatefulWidget extends StatefulWidget {
  /// Initializes [key] for subclasses. as Flutter's StatefulWidget
  const AdharaStatefulWidget({Key key}) : super(key: key);
}

abstract class AdharaState<T extends StatefulWidget> extends State<T> {
  String get tag;

  @override
  void initState() {
    super.initState();
    _callFirstLoad();
  }

  @override
  void setState(VoidCallbackFn fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _callFirstLoad() async {
    Resources r = await ResInheritedWidget.ofFuture(context);
    Scope widgetAppScope = r.appState.getScope("widgetInit");
    bool isInitialized = widgetAppScope.getValue(tag, false);
    if (isInitialized) {
      _callFetchData();
    } else {
      widgetAppScope.setValue(tag, true);
      firstLoad().then((_) => _callFetchData());
    }
  }

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

  Resources _r;
  Resources get r {
    if (_r == null) {
      _r = ResInheritedWidget.of(context);
    }
    return _r;
  }

  on(String eventName, EventHandlerCallback handler){
    r.eventHandler.register(tag, eventName, handler);
  }

  off([String eventName]){
    r.eventHandler.unregister(tag, eventName);
  }

  AdharaEvent trigger(String eventName, dynamic data){
    return r.eventHandler.trigger(eventName, data, tag);
  }

  @protected
  @mustCallSuper
  void dispose() {
    off();
    super.dispose();
  }

}
