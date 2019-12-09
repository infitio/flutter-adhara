import 'package:adhara/app.dart';
import 'package:adhara/configurator.dart';
import 'package:adhara/constants.dart';
import 'package:adhara/datainterface/data/network_provider.dart';
import 'package:adhara/datainterface/data/offline_provider.dart';
import 'package:adhara/datainterface/data_interface.dart';
import 'resources/u.dart';
import 'resources/r.dart';


abstract class AdharaModule extends Configurator {
  AdharaApp app;

  //Will be set by the URL widget which is configure for all modules
  String baseRoute;

  ///Config file to load the JSON configuration from
  String configFile;

  Resources resources;

  ///Data provider state offline/online. Must be one of
  /// [ConfigValues.DATA_PROVIDER_STATE_OFFLINE] and
  /// [ConfigValues.DATA_PROVIDER_STATE_ONLINE]
  String dataProviderState = ConfigValues.DATA_PROVIDER_STATE_ONLINE;

  ///Offline provider class for the application
  OfflineProvider get offlineProvider => OfflineProvider(this);

  ///Network provider class for the application
  NetworkProvider get networkProvider => NetworkProvider(this);

  ///DataInterface class for the application
  DataInterface get dataInterface => DataInterface(this);

  AdharaModuleUtils get utils => AdharaModuleUtils();

  ///Load application configuration
  load(AdharaApp app) async {
    print("loading module...: `$name`");
    this.app = app;
    await loadConfig();
    baseURL = baseURL ?? app.baseURL;
    dbName = dbName ?? app.dbName;
    dbVersion = dbVersion ?? app.dbVersion;
    dataProviderState = dataProviderState ?? app.dataProviderState;
    validateConfig();
  }
}
