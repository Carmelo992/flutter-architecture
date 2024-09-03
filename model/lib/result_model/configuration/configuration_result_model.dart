import 'package:model/data_model/configuration_model.dart';
import 'package:model/result_model/result_model.dart';

abstract class ConfigurationResult extends ModelResult<ConfigurationImage, ConfigurationErrorEnum> {
  ConfigurationResult.error(super.errorValue) : super.error();

  ConfigurationResult.success(super.responseValue) : super.success();
}

enum ConfigurationErrorEnum {
  noConfig,
  missingAuthToken,
  serverError;
}
