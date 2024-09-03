import 'package:model/model.dart';

class ConfigurationResponse extends ConfigurationResult {
  ConfigurationResponse.error(super.errorValue) : super.error();

  ConfigurationResponse.success(super.responseValue) : super.success();
}
