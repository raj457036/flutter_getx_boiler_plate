abstract class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  Either(this._left, this._right, this._isLeft);

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  fold(Function(L? value) l, Function(R? value) r) async {
    if (_isLeft)
      return await l(_left);
    else
      return await r(_right);
  }
}

class Left<L, R> extends Either<L, R> {
  Left(L value) : super(value, null, true);
}

class Right<L, R> extends Either<L, R> {
  Right(R value) : super(null, value, false);
}
