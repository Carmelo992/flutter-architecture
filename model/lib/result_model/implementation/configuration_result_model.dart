import 'package:model/result_model/interface/configuration_result_model_interface.dart';

class ConfigurationResponse extends ConfigurationResponseInterface {
  ConfigurationResponse.error(super.errorValue) : super.error();

  ConfigurationResponse.success(super.responseValue) : super.success();
}
