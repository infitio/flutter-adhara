import 'package:flutter/material.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
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

Route getRoute(RouteSettings routeSettings,
    List<Map<String, dynamic>> namedPatternRoutes) {
  String path = routeSettings.name;
  for (Map<String, dynamic> config in namedPatternRoutes) {
    String urlPattern = config["pattern"];
    // Function router;
    Function router = config["router"];
    Map<String, dynamic> customArguments = config["kwargs"] ?? {};
    /*{
      URLS.productsList: ProductsListPage.router,
      URLS.productDetails: ProductDetailsPage.router,
      URLS.farmerDetails: FarmerDetailsPage.router,
      URLS.editFarmer: FarmerFormPage.router,
      URLS.addFarmerAddress: FarmerAddressFormPage.router,
      URLS.checkoutChooseAddress: CheckoutChooseAddressPage.router,
    }[urlPattern];*/

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
    Map<Symbol, dynamic> kwargs = {};
    for (int idx = 0; idx < pathParamKeys.length; idx++) {
      kwargs[Symbol(pathParamKeys[idx])] = match[idx + 1];
    }

    customArguments.forEach((key, value) {
      kwargs[Symbol(key)] = value;
    });

    ///Instantiate a Material page route and return...
    return MyCustomRoute(
      builder: (context) => Function.apply(router, [], kwargs),
      settings: routeSettings,
    );
  }

  return null;
}
