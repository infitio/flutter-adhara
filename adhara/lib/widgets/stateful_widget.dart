import 'package:adhara/adhara.dart';
import 'package:adhara/resources/_r.dart';
import 'package:adhara/resources/ar.dart';
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
  bool isAppWidget = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _postInit());
  }

  @override
  void setState(VoidCallbackFn fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Map<String, EventHandlerCallback> get eventHandlers => {};

  _postInit() async {
    try{
      await ResourcesInheritedWidget.ofFuture(context);
    }on NoSuchMethodError{
      await AppResourcesInheritedWidget.ofFuture(context);
      isAppWidget = true;
    }
    // ^ just waiting to load resources, nothing else
    _registerEventListeners();
    await _callFirstLoad();
  }

  _registerEventListeners(){
    Map<String, EventHandlerCallback> _eh = eventHandlers;
    if (_eh.length > 0) {
      eventHandlers.forEach((eventName, handler) {
        this.on(eventName, handler);
      });
    }
  }

  _callFirstLoad() async {
    if (isFirstLoadComplete) {
      await _callFetchData();
    } else {
      firstLoad().then((_) async {
        rOrAr.appState.getScope("widgetInit").setValue(tag, true);
        await _callFetchData();
      });
    }
  }

  bool get isFirstLoadComplete{
    return rOrAr.appState.getScope("widgetInit").getValue(tag, false);
  }

  _callFetchData() async {
    if(isAppWidget){
      await fetchAppLevelData(await AppResourcesInheritedWidget.ofFuture(context));
    }else{
      await fetchData(await ResourcesInheritedWidget.ofFuture(context));
    }
  }

  ///firstLoad will e called only once per widget [Type] in lifecycle of the application
  ///
  /// Say WidgetX extends [AdharaState], and WidgetX is used in 2 places
  /// firstLoad will be called only once for 2 places
  firstLoad() async {
    /*Do Nothing*/
  }

  ///fetchAppLevelData will be called always for each app level widget where
  ///module resource will not be available.
  /// Use this to fetch any data and assign local variables
  fetchAppLevelData(AppResources r) async {
    /*Do Nothing*/
  }

  ///fetch data will be called always for each widget
  /// Use this to fetch any data and assign local variables
  fetchData(Resources r) async {
    /*Do Nothing*/
  }

  ///Resources and AppResources objects
  Resources _r;
  AppResources _ar;

  ///Resources getter
  Resources get r {
    if (_r == null) {
      _r = ResourcesInheritedWidget.of(context);
    }
    return _r;
  }

  ///AppResources getter
  AppResources get ar {
    if (_ar == null) {
      _ar = AppResourcesInheritedWidget.of(context);
    }
    return _ar;
  }

  BaseResources get rOrAr => isAppWidget?ar:r;

  ///Listen to events by providing [eventName], [handler]
  on(String eventName, EventHandlerCallback handler) {
    rOrAr.eventHandler.register(tag, eventName, handler);
  }

  ///turn of event listening by providing specific [eventName]
  off([String eventName]) {
    rOrAr.eventHandler.unregister(tag, eventName);
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
