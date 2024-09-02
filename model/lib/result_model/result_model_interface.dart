abstract class ResultInterface<SUCCESS, ERROR> {
  SUCCESS? responseValue;

  ERROR? errorValue;

  ResultInterface.success(SUCCESS this.responseValue);

  ResultInterface.error(ERROR this.errorValue);
}
