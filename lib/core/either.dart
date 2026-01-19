/// Either type for functional error handling
/// Left represents a Failure, Right represents a Success value
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  Either._(this._left, this._right, this._isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  L get left {
    if (_isLeft) return _left!;
    throw Exception('Called left on a Right');
  }

  R get right {
    if (!_isLeft) return _right!;
    throw Exception('Called right on a Left');
  }

  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    return _isLeft ? leftFn(_left!) : rightFn(_right!);
  }

  Either<L, T> map<T>(T Function(R right) fn) {
    return _isLeft ? Either.left(_left!) : Either.right(fn(_right!));
  }

  Either<T, R> mapLeft<T>(T Function(L left) fn) {
    return _isLeft ? Either.left(fn(_left!)) : Either.right(_right!);
  }

  Either<L, T> flatMap<T>(Either<L, T> Function(R right) fn) {
    return _isLeft ? Either.left(_left!) : fn(_right!);
  }

  R getOrElse(R Function() defaultValue) {
    return _isLeft ? defaultValue() : _right!;
  }

  R? get rightOrNull => _isLeft ? null : _right;
  L? get leftOrNull => _isLeft ? _left : null;

  @override
  String toString() {
    return _isLeft ? 'Left($_left)' : 'Right($_right)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Either<L, R> &&
        other._isLeft == _isLeft &&
        (_isLeft ? other._left == _left : other._right == _right);
  }

  @override
  int get hashCode {
    return _isLeft ? _left.hashCode : _right.hashCode;
  }
}
