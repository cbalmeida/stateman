import 'package:flutter/material.dart';
import 'package:flutter_stateman/src/stateman_service_container.dart';
import 'package:flutter_stateman/src/stateman_storage.dart';

class StateManMain extends StatefulWidget {
  const StateManMain({
    super.key,
    required this.child,
    required this.serviceContainerInitializer,
  });
  final StateManServiceContainer Function() serviceContainerInitializer;
  final Widget child;

  @override
  StateManMainState createState() => StateManMainState();
}

class StateManMainState extends State<StateManMain> {
  late StateManServiceContainer serviceContainer;

  @override
  void initState() {
    super.initState();
    serviceContainer = widget.serviceContainerInitializer();
  }

  @override
  Widget build(BuildContext context) {
    return StateManStorage(
      serviceContainer: serviceContainer,
      child: widget.child,
    );
  }
}
