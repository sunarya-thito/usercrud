import 'package:flutter/widgets.dart';

extension DataWidgetExtension on BuildContext {
  T data<T>() => DataWidget.of<T>(this);
  T? maybeData<T>() => DataWidget.maybeOf<T>(this);
}

class DataWidget<T> extends InheritedWidget {
  final T value;

  const DataWidget({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  static T of<T>(BuildContext context) {
    final DataWidget<T>? result =
        context.dependOnInheritedWidgetOfExactType<DataWidget<T>>();
    assert(result != null, 'No DataWidget found in context');
    return result!.value;
  }

  static T? maybeOf<T>(BuildContext context) {
    final DataWidget<T>? result =
        context.dependOnInheritedWidgetOfExactType<DataWidget<T>>();
    return result?.value;
  }

  @override
  bool updateShouldNotify(DataWidget<T> oldWidget) {
    return value != oldWidget.value;
  }
}
