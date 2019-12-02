import 'package:adhara/resources/ar.dart';
import 'package:adhara/resources/ri.dart';
import 'package:adhara/resources/url.dart';
import 'package:flutter/material.dart';

typedef Widget RouterWidgetBuilder(
    BuildContext context, RoutableURL matchingUrl, Widget widget);

class AdharaRoute<T> extends MaterialPageRoute<T> {
  AdharaRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class Router {
  static RegExp urlRegExp = RegExp("\\{\\{[a-zA-Z\$_][a-zA-Z0-9\$_]*\\}\\}");

  static Match getMatch(String path, String urlPattern) {
    ///Cleanup the url pattern and remove all mustache patterns, viz., {{asd092s1}}
    urlPattern = urlPattern.replaceAll(Router.urlRegExp, '');

    ///current path with URL pattern, extract matches out of
    /// the first match as its a single match with multiple positional matches.
    return RegExp(urlPattern).firstMatch(path);
  }

  static getAdharaRoute(RouteSettings routeSettings, RoutableURL url,
      RouterWidgetBuilder builder) {
    CallableRouter router = url.router;
    Map<String, dynamic> customArguments = url.kwArgs ?? {};
    String urlPattern = url.pattern;

    ///Extracting path parameter keys.
    ///These keys will be used to call the router functions
    ///all extracts from path that match the mustache patterns
    ///viz., {{asd092s1}}, are extracted and stored in pathParamKeys
    List pathParamKeys = RegExp("{{([a-zA-Z\$_][a-zA-Z0-9\$_]*)}}")
        .allMatches(urlPattern)
        .map((Match m) => m.group(1))
        .toList();

    Match match = Router.getMatch(routeSettings.name, url.pattern);

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
    Widget widget =
        (router == null) ? null : Function.apply(router, [], kwArgs);
    return AdharaRoute(
      builder: (context) =>
          (builder == null) ? widget : builder(context, url, widget),
      settings: routeSettings,
    );
  }

  ///[routeSettings] - Material app's route settings
  ///[urls] - application route configuration.
  /// Simply putting it, URL -> Widget mapping
  /// This can be considered as something like a
  /// urls.py for django or struts.xml for struts
  static Route getRoute(RouteSettings routeSettings, List<URL> urls,
      {RouterWidgetBuilder builder}) {
    for (URL url in urls) {
      ///If no match, then this URL is no good
      if (Router.getMatch(routeSettings.name, url.pattern) == null) {
        continue;
      }

      /// Routing module resources
      if (url.module != null) {
        for (URL moduleURL in url.module.urls) {
          ///If no match, then this URL is no good
          if (Router.getMatch(routeSettings.name, moduleURL.getPattern(url)) ==
              null) {
            continue;
          }
          RoutableURL routableModuleURL = moduleURL.routableURL;
          routableModuleURL.pattern = moduleURL.getPattern(url);
          routableModuleURL.module = url.module;
          return Router.getAdharaRoute(
              routeSettings, routableModuleURL, builder);
        }
      }

      ///if no module resource paths match, do app level navigation
      return Router.getAdharaRoute(routeSettings, url.routableURL, builder);
    }
    return null;
  }

  static Function getAppRouteGenerator(AppResources ar) {
    for(URL url in ar.app.urls){
      if(url.module!=null){
        url.module.baseRoute = url.pattern;
      }
    }
    Route routeGenerator(RouteSettings routeSettings) {
      Route route = getRoute(routeSettings, ar.app.urls, builder:
          (BuildContext context, RoutableURL matchingUrl, Widget widget) {
        if (matchingUrl.module == null) {
          return widget;
        }
        return ResourcesInheritedWidget(
            resources: ar.getModuleResource(matchingUrl.module.name),
            child: widget);
      });
      return route;
    }

    return routeGenerator;
  }
}
