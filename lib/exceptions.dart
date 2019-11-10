class AdharaException implements Exception {
  String cause;

  AdharaException(this.cause);

  @override
  String toString() {
    return this.cause;
  }
}

class AdharaResourceNotFound implements AdharaException {
  String cause;

  AdharaResourceNotFound(this.cause);
}

class AdharaAppModuleNotFound implements AdharaException {
  String cause;

  AdharaAppModuleNotFound(this.cause);
}