abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get data => isSuccess ? (this as Success<T>).data : throw Exception();
  String get error => isFailure ? (this as Failure<T>).error : '';
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  @override
  final String error;
  const Failure(this.error);
}
