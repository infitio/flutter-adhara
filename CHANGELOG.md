## [0.0.28] - 19th July, 2018.

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