

class RequestResultModel<T> {

  final bool result;
  final T? value;
  final String? error;

  RequestResultModel({
    required this.result,
    this.value,
    this.error,
  });
}
