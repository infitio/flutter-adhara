class ResourceNotFound implements Exception {
  String cause;

  ResourceNotFound(this.cause);
}
