import 'package:flutter/material.dart';

typedef Factory<T> = T Function(StateManServiceContainer container);

class StateManServiceContainer {
  StateManServiceContainer.scoped()
      : _serviceProviders =
            <String?, Map<Type, _StateManServiceProvider<Object>>>{};

  static final StateManServiceContainer _instance =
      StateManServiceContainer.scoped();

  factory StateManServiceContainer() => _instance;

  final Map<String?, Map<Type, _StateManServiceProvider<Object>>>
      _serviceProviders;

  /*
  void registerInstance<S>(S instance, {String? name}) {
    _setServiceProvider(name, _StateManServiceProvider<S>.instance(instance));
  }

  void registerFactory<S>(Factory<S> factory, {String? name}) {
    _setServiceProvider(name, _StateManServiceProvider<S>.factory(factory));
  }

  void registerSingleton<S>(Factory<S> factory, {String? name}) {
    _setServiceProvider(name, _StateManServiceProvider<S>.singleton(factory));
  }
   */

  void register<S>(Factory<S> factory, {String? name}) {
    _setServiceProvider(name, _StateManServiceProvider<S>.singleton(factory));
  }

  void unregister<T>([String? name]) {
    if (!(_serviceProviders[name]?.containsKey(T) ?? false)) {
      throw FlutterError(
          'Error when unregistering `$T`:\n\nType `$T` is not registered ${name == null ? '' : 'for the name `$name`'}');
    }
    _serviceProviders[name]?.remove(T);
  }

  T resolve<T>([String? name]) {
    final providers =
        _serviceProviders[name] ?? <Type, _StateManServiceProvider<Object>>{};
    if (!(providers.containsKey(T))) {
      throw FlutterError(
          'Error when resolving `$T`:\n\nType `$T` is not registered ${name == null ? '' : 'for the name `$name`'}');
    }

    final value = providers[T]?.get(this);
    if (value == null) {
      throw FlutterError(
          'Failed to resolve `$T`:\n\nThe type `$T` was not registered ${name == null ? '' : 'for the name `$name`'}');
    }
    if (value is T) return value as T;
    throw FlutterError(
        'Failed to resolve `$T`:\n\nValue is not registered as `$T`\n\nThe type `$T` is not registered ${name == null ? '' : 'for the name `$name`'}');
  }

  @visibleForTesting
  T? resolveAs<S, T extends S>([String? name]) {
    final obj = resolve<S>(name);
    if (obj is! T) {
      throw FlutterError(
          'Failed to resolve `$S` as `$T`:\n\nThe type `$S` as `$T` is not registered ${name == null ? '' : 'for the name `$name`'}');
    }
    if (obj == null) return null;
    return obj;
  }

  T call<T>([String? name]) => resolve<T>(name);

  void clear() {
    _serviceProviders.clear();
  }

  void _setServiceProvider<T>(
      String? name, _StateManServiceProvider<T> provider) {
    final nameProviders = _serviceProviders;
    if ((nameProviders.containsKey(name) &&
        nameProviders[name]!.containsKey(T))) {
      throw FlutterError(
          'The type `$T` is already registered ${name == null ? '' : 'for the name `$name`'}');
    }
    _serviceProviders.putIfAbsent(
            name, () => <Type, _StateManServiceProvider<Object>>{})[T] =
        provider as _StateManServiceProvider<Object>;
  }
}

class _StateManServiceProvider<T> {
  // _StateManServiceProvider.instance(this.object) : _instanceBuilder = null, _singleton = false;

  // _StateManServiceProvider.factory(this._instanceBuilder) : _singleton = false;

  _StateManServiceProvider.singleton(this._instanceBuilder) : _singleton = true;

  final Factory<T>? _instanceBuilder;
  T? object;
  bool _singleton = false;

  T? get(StateManServiceContainer container) {
    final instanceBuilder = _instanceBuilder;
    if (_singleton && instanceBuilder != null) {
      object = instanceBuilder(container);
      _singleton = false;
    }

    if (object != null) {
      return object;
    }

    if (instanceBuilder != null) {
      return instanceBuilder(container);
    }

    return null;
  }
}
