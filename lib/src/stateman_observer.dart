import 'package:flutter/material.dart';
import 'package:flutter_stateman/src/stateman_storage.dart';

class StateManObserver<T extends Listenable> extends StatelessWidget {
  final Widget Function(BuildContext context, T state, Widget? child) builder;
  final Widget? child;
  const StateManObserver({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    T state = StateManStorage.store<T>(context);
    return AnimatedBuilder(
      animation: state,
      child: child,
      builder: (BuildContext context, Widget? child) => builder(context, state, child),
    );
  }
}

class StateManObserver2<T1 extends Listenable, T2 extends Listenable> extends StatelessWidget {
  final Widget Function(BuildContext context, T1 state1, T2 state2, Widget? child) builder;
  final Widget? child;
  const StateManObserver2({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    T1 state1 = StateManStorage.store<T1>(context);
    T2 state2 = StateManStorage.store<T2>(context);
    return AnimatedBuilder(
      animation: state1,
      child: child,
      builder: (BuildContext context, Widget? child) => AnimatedBuilder(
        animation: state2,
        child: child,
        builder: (BuildContext context, Widget? child) => builder(context, state1, state2, child),
      ),
    );
  }
}

class StateManObserver3<T1 extends Listenable, T2 extends Listenable, T3 extends Listenable> extends StatelessWidget {
  final Widget Function(BuildContext context, T1 state1, T2 state2, T3 state3, Widget? child) builder;
  final Widget? child;
  const StateManObserver3({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    T1 state1 = StateManStorage.store<T1>(context);
    T2 state2 = StateManStorage.store<T2>(context);
    T3 state3 = StateManStorage.store<T3>(context);
    return AnimatedBuilder(
      animation: state1,
      child: child,
      builder: (BuildContext context, Widget? child) => AnimatedBuilder(
        animation: state2,
        child: child,
        builder: (BuildContext context, Widget? child) => AnimatedBuilder(
          animation: state3,
          child: child,
          builder: (BuildContext context, Widget? child) => builder(context, state1, state2, state3, child),
        ),
      ),
    );
  }
}

class StateManObserver4<T1 extends Listenable, T2 extends Listenable, T3 extends Listenable, T4 extends Listenable> extends StatelessWidget {
  final Widget Function(BuildContext context, T1 state1, T2 state2, T3 state3, T4 state4, Widget? child) builder;
  final Widget? child;
  const StateManObserver4({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    T1 state1 = StateManStorage.store<T1>(context);
    T2 state2 = StateManStorage.store<T2>(context);
    T3 state3 = StateManStorage.store<T3>(context);
    T4 state4 = StateManStorage.store<T4>(context);
    return AnimatedBuilder(
      animation: state1,
      child: child,
      builder: (BuildContext context, Widget? child) => AnimatedBuilder(
        animation: state2,
        child: child,
        builder: (BuildContext context, Widget? child) => AnimatedBuilder(
          animation: state3,
          child: child,
          builder: (BuildContext context, Widget? child) => AnimatedBuilder(
            animation: state4,
            child: child,
            builder: (BuildContext context, Widget? child) => builder(context, state1, state2, state3, state4, child),
          ),
        ),
      ),
    );
  }
}
