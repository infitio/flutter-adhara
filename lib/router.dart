import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/r.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/resources/url.dart';
import 'package:flutter/material.dart';

typedef Widget RouterWidgetBuilder(BuildContext context, URL matchingUrl, Function fn);

class AdharaRouter<T> extends MaterialPageRoute<T> {
  AdharaRouter({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }

  ///[routeSettings] - Material app's route settings
  ///[urls] - application route configuration.
  /// Simply putting it, URL -> Widget mapping
  /// This can be considered as something like a
  /// urls.py for django or struts.xml for struts
  static Route getRoute(RouteSettings routeSettings, List<URL> urls, {
    RouterWidgetBuilder builder
  }) {
    String path = routeSettings.name;
    for (URL url in urls) {
      String urlPattern = url.pattern;
      Function router = url.router;
      Map<String, dynamic> customArguments = url.kwArgs ?? {};

      ///Extracting path parameter keys.
      ///These keys will be used to call the router functions
      ///all extracts from path that match the mustache patterns
      ///viz., {{asd092s1}}, are extracted and stored in pathParamKeys
      List pathParamKeys = RegExp("{{([a-zA-Z\$_][a-zA-Z0-9\$_]*)}}")
          .allMatches(urlPattern)
          .map((Match m) => m.group(1))
          .toList();

      ///Cleanup the url pattern and remove all mustache patterns, viz., {{asd092s1}}
      urlPattern = urlPattern.replaceAll(
          RegExp("\\{\\{[a-zA-Z\$_][a-zA-Z0-9\$_]*\\}\\}"), '');

      ///current path with URL pattern, extract matches out of
      /// the first match as its a single match with multiple positional matches.
      Match match = RegExp(urlPattern).firstMatch(path);

      ///If no match, then this URL is no good
      if (match == null) {
        continue;
      }

      ///If matched, create a [Map]<[Symbol], [dynamic]> which can be used to
      /// call function by using [Function.apply]
      Map<Symbol, dynamic> kwArgs = {};
      for (int idx = 0; idx < pathParamKeys.length; idx++) {
        kwArgs[Symbol(pathParamKeys[idx])] = match[idx + 1];
      }

      customArguments.forEach((key, value) {
        kwArgs[Symbol(key)] = value;
      });

      ///Instantiate a Material page route and return...
      ///With custom transition - Defaults to fade
      return AdharaRouter(
        builder: (context) => builder(context, url, Function.apply(router, [], kwArgs)),
        settings: routeSettings,
      );
    }

    return null;
  }

  static Function getAppRouteGenerator(AppResources r) {
    Route routeGenerator(RouteSettings routeSettings){
      Route route = getRoute(routeSettings, r.app.urls,
          builder: (BuildContext context, URL matchingUrl, Function fn){
            return ResourcesInheritedWidget(
                resources: r.getModuleResource(matchingUrl.module.name),
                child: matchingUrl.module.container
            );
          });
      return route;
    }
    return routeGenerator;
  }

  static Function getRouteGenerator(Resources r) {
    Route routeGenerator(RouteSettings routeSettings){
      Route route = getRoute(routeSettings, r.module.urls);
      return route;
    }
    return routeGenerator;
  }

}
