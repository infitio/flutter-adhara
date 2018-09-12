import 'package:adhara/config.dart';
import 'package:adhara/datainterface/storage/key_value_storage_provider.dart';

@deprecated
class HTTPStorageProvider extends KeyValueStorageProvider {
  HTTPStorageProvider(Config config) : super(config);

  get tableName => "HTTP_STORAGE";
}
