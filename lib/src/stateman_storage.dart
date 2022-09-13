import 'package:flutter/material.dart';
import 'package:flutter_stateman/src/stateman_service_container.dart';

class StateManStorage extends InheritedWidget {
  const StateManStorage({super.key, required this.serviceContainer, required super.child});
  final StateManServiceContainer serviceContainer;

  static StateManServiceContainer container(BuildContext context) {
    final StateManStorage? stateManStorage = context.dependOnInheritedWidgetOfExactType<StateManStorage>();
    if (stateManStorage == null) throw FlutterError('There is no StateManStorage widget in the tree.\nThis usually happens when the StateManMain was not created on the top of the widget tree.');
    return stateManStorage.serviceContainer;
  }

  static T retrieve<T>(BuildContext context, [String? name]) {
    T result = container(context).resolve<T>(name);
    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
