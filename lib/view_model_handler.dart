import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewModelHandler<T extends BaseViewModel> extends InheritedWidget {
  final T viewModel;

  ViewModelHandler({required this.viewModel, super.key, required Widget child})
      : super(
          child: PopScope(
            child: child,
            onPopInvoked: (_) {
              viewModel.disposed();
            },
          ),
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static T of<T extends BaseViewModel>(BuildContext context) {
    var widget = context.dependOnInheritedWidgetOfExactType<ViewModelHandler<T>>();
    if (widget == null) {
      throw FlutterError(
        '''
        ViewModelHandler not able to find view model of type: $T
        
        Check if you're calling this method above ViewModelHandler<$T>.of(context); 
        ''',
      );
    }
    return widget.viewModel;
  }
}

abstract class BaseViewModel {
  void disposed();
}

class ViewModel implements BaseViewModel {
  ValueListenable<int> get value => _value;
  final ValueNotifier<int> _value = ValueNotifier(0);

  void increment() {
    _value.value = _value.value + 1;
  }

  @override
  void disposed() {
    print("view model disposed with value = ${_value.value} ");
  }
}
