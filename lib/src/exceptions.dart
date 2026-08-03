class GapLocationException implements Exception {
  final String _cause;

  GapLocationException(this._cause) : super();

  @override
  String toString() => _cause;
}

class NonAppropriatePathException implements Exception {
  final String _cause;

  NonAppropriatePathException(this._cause) : super();

  @override
  String toString() => _cause;
}

class IllegalFloatingActionButtonSizeException implements Exception {
  final String _cause;

  IllegalFloatingActionButtonSizeException(this._cause) : super();

  @override
  String toString() => _cause;
}
