import 'package:model/result_model/configuration/configuration_result_model.dart';

class ConfigurationResultImpl extends ConfigurationResult {
  ConfigurationResultImpl.error(super.errorValue) : super.error();

  ConfigurationResultImpl.success(super.responseValue) : super.success();
}
