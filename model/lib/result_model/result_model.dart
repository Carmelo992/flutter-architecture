abstract class ModelResult<SUCCESS, ERROR> {
  SUCCESS? responseValue;

  ERROR? errorValue;

  ModelResult.success(SUCCESS this.responseValue);

  ModelResult.error(ERROR this.errorValue);
}
