## [0.1.59] - 21st November, 2018

* expanding network provider to an abstract classes data provider
 and 2 implementation classes network and offline

* Offline provider can be helpful for data mocking in development
  Data mock can be stored in assets/data/<API_URL_AS_PATH>/<METHOD>.json file

  For example:
  ```
  Network Provider(Online) calls GET '/api/v1/items',
  Using Offline provider one can mock the data by creating '/assets/data/api/v1/items/get.json'
  (or)
  Network Provider(Online) calls DELETE '/api/v1/items/1',
  Using Offline provider one can mock the data by creating '/assets/data/api/v1/items/1/delete.json'
  ```

  Note that method name must be lowercase
  Offline provider greatly helps in integrated testing with data

## [0.1.58] - 21st November, 2018

* Introducing few commonly used widgets: Fetching, NoData, Paginator, PullToRefresh

## [0.1.57] - 21st November, 2018

* Introducing few commonly used widgets: Fetching, NoData, Paginator, PullToRefresh

## [0.1.55] - 14th November, 2018

* AdharaStatefulWidget~isFirstLoadComplete was returning wrong status, issue fixed.

## [0.1.54] - 14th November, 2018

* code optimization

## [0.1.53] - 14th November, 2018

* removing fragile socket.io dependency thereby removing support for webSockets.
* new getter fromFile in Config. Using this configuration json variables can be accessed

## [0.1.52] - 12th November, 2018

* Bug Fix for filter and exclude combinations in dataInterface.query

## [0.1.51] - 9th November, 2018

* Optimize setData in KeyValueStorageProvider

## [0.1.50] - 6th November, 2018

* isFirstLoadComplete getter to know if the widget has completed loading for the very first time in app lifecycle

## [0.1.48] - 14th October, 2018

* `registerSocketEvents` removed. added `get eventHandlers => {};` this should return event-handler map.
* Example:
```dart
get eventHandlers => {
    'app:new-notification': this.refreshNotificationIcon
};
```

## [0.1.45] - 14th October, 2018

* `registerSocketEvents` signature changed to `Future registerSocketEvents(SocketIO socket);`

## [0.1.44] - 14th October, 2018.

* Introducing socket connections using socket.io
* Override registerSocketEvents from NetworkProvider and use instance level `socket` field to listen to events
* Usage
    ```dart
    //example
    Future registerSocketEvents() async {
        await socket.on('message', (greeting) {
          print('Hello, $greeting');
        });
        await socket.emit('init', [
          {'Hello': 'world!'},
        ]);
      }
    ```

## [0.1.43] - 14th October, 2018.

* Optimized/Enhanced event handler. Introducing Event object

## [0.1.42] - 14th October, 2018.

* Introducing event handler. Register and trigger events across widgets.
* Usage:
    inside State class extending AdharaState,
    ```
    on("eventName", handlerFn);     //to register
    off("eventName")                //to de-register
    trigger("someOtherEvent")       //to trigger event across all mounted stateful widgets
    ```

## [0.1.41] - 13th October, 2018.

* Removed HTTPStorageProvider support. Use KeyValue storage provider if required, or create a HTTPStorage provider extending KeyValueStorage.

## [0.1.40] - 13th October, 2018.

* Removed storage provider schema configurations. Only fields can be configured now using storage_classes

## [0.1.39] - 13th October, 2018.

* Dart 2.0 Support.

## [0.1.33] - 08th October, 2018.

* KeyValueStorageProvider - value was Unique, now changed to non unique

## [0.1.32] - 28th September, 2018.

* printing preload errors

## [0.1.31] - 28th September, 2018.

* Enforcing usage of

## [0.1.30] - 28th September, 2018.

* Config can now configure config configFile field which returns a file from assets - config file. this eases up development files...

## [0.1.25] - 28th September, 2018.

* flutter's presky setState error in development for "setState called after dispose" is suppressed by performing a check in adhara's stateful_widget

## [0.1.24] - 27th September, 2018.

* Enhanced logging for network calls

## [0.1.22] - 26th September, 2018.

* Bug Fix for constraints in Schema Columns

## [0.1.21] - 24th September, 2018.

* Enhancements in bean.dart

## [0.1.19] - 21th September, 2018.

* Bug Fixes in 0.1.0

## [0.1.0] - 13th September, 2018.

* Storage Field classes introduced. table schema can now be declared easily with introduced classes by making field types mandatory
* Storage Field classes will support storing boolean/json fields - serialization and deserialization will be taken care by these classes

## [0.0.45] - 2nd September, 2018.

* Adding examples

## [0.0.44] - 2nd September, 2018.

* Adding shared preferences in Resources. User r.preferences to access shared_preferences API's

## [0.0.42] - 29th August, 2018.

* Reverting to previous

## [0.0.41] - 29th August, 2018.

* Upgrade all dependencies to latest

## [0.0.39] - 29th August, 2018.

* Resources made available in DataInterface by public field `r`.

## [0.0.38] - 19th August, 2018.

* Router's getRoute function's argument urlPatterns now accepts kwargs, ex: `{"pattern": "^posts/{{postId}}([0-9]+)/edit\$", "router": NewPost.router, "kwargs": {"edit": true}},`

## [0.0.36] - 17th August, 2018.

* Storage provider create table error handled for IOS

## [0.0.35] - 12th August, 2018.

* Sentry ignore strings introduced. `List<String> get sentryIgnoreStrings` in `Config`

## [0.0.34] - 11th August, 2018.

* Adding sentry. use Config.sentryDSN to configure sentry data source name

## [0.0.32] - 7th August, 2018.

* NetworkProvider enhanced. Interceptors introduced.

## [0.0.30] - 4th August, 2018.

* single instance database referred from resources. It is expected to be auto closed on app closing...

## [0.0.28] - 1st August, 2018.

* loadLanguage introduced. Can call this to load new languages whenever required

## [0.0.28] - 29th July, 2018.

* clearResources introduced. This can be called on logout from the application.
* clearResources by default clear's AppState and calls DataInterface's clearDataStores method.
* dataStores getter introduced in DataInterface. This must return all data stores whose creation and truncation will be handled with easy utils.

## [0.0.27] - 19th July, 2018.

* Mode utilities added

## [0.0.25] - 19th July, 2018.

* Introducing tag for AdharaState to manage state related unique variables

## [0.0.22] - 19th July, 2018.

* Dart 2 support

## [0.0.22] - 19th July, 2018.

* All calling functions enhanced with same signature

## [0.0.21] - 19th July, 2018.

* StorageProvider methods relating to get list now accepts all arguments supported by sqflite

## [0.0.20] - 19th July, 2018.

* StorageProvider delete operation Signature changes

## [0.0.18] - 19th July, 2018.

* Introducing Batch Udpate.

## [0.0.16] - 18th July, 2018.

* Created time and Updated time for all beans and storage's.

## [0.0.13] - 18th July, 2018.

* Introducing AdharaStatelessWidget. Use buildWithResources(BuildContext context, Resources r) to access resources.

## [0.0.12] - 15th July, 2018.

* Network provider failure responses now throw error

## [0.0.10] - 15th July, 2018.

* App state scope get and set method names changed to getValue setValue.
* default value made optional for getValue

## [0.0.6] - 15th July, 2018.

* providing r as a getter in adhara stateful widget

## [0.0.5] - 15th July, 2018.

* Introducing remove in KeyValueStorageProvider

## [0.0.4] - 15th July, 2018.

* Adding option for custom data interface in config.dart

## [0.0.2] - 15th July, 2018.

* Adding URL launcher as a single function call which abstracts checks for canLaunch

## [0.0.1] - 15th July, 2018.

* AdharaStatefulWidget and AdharaSState to manage lifecycle events for data
* Resource Handling for languages
* Router to handle URL's by path
* SQFLite integrated for database interactions
* Bean (~ POJO classes from Java) based storage handlers
* KeyValue stores in database
* http storage for URL based storage