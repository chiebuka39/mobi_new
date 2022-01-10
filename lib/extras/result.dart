class Result<T> {
  T data;
  String message;
  bool error;

  Result({this.data, this.error, this.message});
}