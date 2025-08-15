class AppError {
  final String massage;
  final Object? cause;

  AppError(this.message, [this.cause]);

  @override
  String toString() => 'AppError{message: $message, cause: $cause}';
}