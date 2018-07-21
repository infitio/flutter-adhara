import 'package:adhara/config.dart';
import 'package:adhara/datainterface/storage/key_value_storage_provider.dart';

class HTTPStorageProvider extends KeyValueStorageProvider {
  HTTPStorageProvider(Config config) : super(config);

  get tableName {
    return "HTTP_STORAGE";
  }
}
