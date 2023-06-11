import 'dart:async';

class SimpleBloc<T> {
  final _controller = StreamController<T>();

  Stream<T> get stream => _controller.stream;

  add(T object) {
    _controller.add(object);
  }

  addError(Object error) {
    if (!_controller.isClosed) _controller.addError(error);
  }

  dispose() {
    _controller.close();
  }
}
