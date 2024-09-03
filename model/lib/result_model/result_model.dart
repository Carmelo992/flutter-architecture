abstract class ResultModel<SUCCESS, ERROR> {
  SUCCESS? responseValue;

  ERROR? errorValue;

  ResultModel.success(SUCCESS this.responseValue);

  ResultModel.error(ERROR this.errorValue);
}
