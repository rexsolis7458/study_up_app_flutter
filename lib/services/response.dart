class APiResponse<T> {
  T? data;
  bool error;
  String? errorMessage;
  APiResponse({this.data, this.error = false, this.errorMessage});
}
