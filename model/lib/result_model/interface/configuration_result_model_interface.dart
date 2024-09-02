import 'package:model/data_model/configuration_model.dart';
import 'package:model/result_model/result_model_interface.dart';

abstract class ConfigurationResponseInterface extends ResultInterface<ConfigurationImage, ConfigurationErrorEnum> {
  ConfigurationResponseInterface.error(super.errorValue) : super.error();

  ConfigurationResponseInterface.success(super.responseValue) : super.success();
}

enum ConfigurationErrorEnum {
  noConfig,
  missingAuthToken,
  serverError;
}
