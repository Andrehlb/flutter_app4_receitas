class AppError {
  final String message;
  final Object? cause;

  AppError(this.message, [this.cause]);

  @override
  String toString() => 'AppError{message: $message, cause: $cause}';
}