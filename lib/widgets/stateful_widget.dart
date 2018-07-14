import 'package:flutter/material.dart';
import 'package:adhara/resources/app_state.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/resources/r.dart';


abstract class AdharaStatefulWidget extends StatefulWidget {

}

abstract class AdharaState<T extends StatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
    _callFirstLoad();
  }

  _callFirstLoad() async {
    Resources r = await ResInheritedWidget.ofFuture(context);
    Scope widgetAppScope = r.appState.getScope("widgetInit");
    bool isInitialized = widgetAppScope.get(this, false);
    if(isInitialized) {
      _callFetchData();
    }else{
      widgetAppScope.set(this, true);
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

  get resources => ResInheritedWidget.of(context);

}