import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateman/stateman.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateManMain(
      serviceContainerInitializer: () => StateManServiceContainer()
        ..register((container) => CounterRepository1())
        ..register((container) => CounterRepository2())
        ..register((container) => CounterRepository3())
        ..register((container) => CounterStore1(container.resolve<CounterRepository1>()))
        ..register((container) => CounterStore2(container.resolve<CounterRepository2>()))
        ..register((container) => CounterStore3(container.resolve<CounterRepository3>()))
        ..register((container) => CounterStoreTotal([container.resolve<CounterStore1>(), container.resolve<CounterStore2>(), container.resolve<CounterStore3>()])),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CountersPage(),
      ),
    );
  }
}

class CountersPage extends StatelessWidget {
  const CountersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counters")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            StateManObserver<CounterStore1>(builder: (context, counterStore1, child) {
              return CounterWidget(store: counterStore1);
            }),
            StateManObserver<CounterStore2>(builder: (context, counterStore2, child) {
              return CounterWidget(store: counterStore2);
            }),
            StateManObserver<CounterStore3>(builder: (context, counterStore3, child) {
              return CounterWidget(store: counterStore3);
            }),
            const Spacer(),
            StateManObserver<CounterStoreTotal>(builder: (context, counterStoreTotal, child) {
              return Text("Total: ${counterStoreTotal.value}");
            }),
            const Spacer(),
            FloatingActionButton(
                onPressed: () {
                  StateManStorage.store<CounterStoreTotal>(context).reset();
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.clear)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final CounterStore store;

  const CounterWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(onPressed: () => store.decrement(), child: const Icon(Icons.exposure_minus_1)),
            Text('${store.value}', style: Theme.of(context).textTheme.headline4),
            FloatingActionButton(onPressed: () => store.increment(), child: const Icon(Icons.exposure_plus_1)),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// repositories, stores, etc...
/// ============================================

/// --------------------------------------------
/// repositories
/// --------------------------------------------

abstract class ICounterRepository {
  Future<int> get();
  Future<bool> put(int value);
}

class CounterRepository extends ICounterRepository {
  final String counterId;

  CounterRepository(this.counterId);

  @override
  Future<int> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(counterId) ?? 0;
  }

  @override
  Future<bool> put(int value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(counterId, value);
  }
}

class CounterRepository1 extends CounterRepository {
  CounterRepository1() : super('counter1');
}

class CounterRepository2 extends CounterRepository {
  CounterRepository2() : super('counter2');
}

class CounterRepository3 extends CounterRepository {
  CounterRepository3() : super('counter3');
}

/// --------------------------------------------
/// stores
/// --------------------------------------------

abstract class ICounterStore extends ChangeNotifier {
  int get value;
  void initialize();
  void increment();
  void decrement();
  void reset();
}

class CounterStore extends ICounterStore {
  final ICounterRepository repository;

  int _value = 0;

  CounterStore(this.repository) {
    initialize();
  }

  @override
  void initialize() async {
    repository.get().then((value) {
      _value = value;
      notifyListeners();
    });
  }

  @override
  int get value => _value;

  @override
  increment() {
    _value++;
    repository.put(_value);
    notifyListeners();
  }

  @override
  void decrement() {
    _value--;
    repository.put(_value);
    notifyListeners();
  }

  @override
  void reset() {
    _value = 0;
    repository.put(_value);
    notifyListeners();
  }
}

class CounterStore1 extends CounterStore {
  CounterStore1(ICounterRepository repository) : super(repository);
}

class CounterStore2 extends CounterStore {
  CounterStore2(ICounterRepository repository) : super(repository);
}

class CounterStore3 extends CounterStore {
  CounterStore3(ICounterRepository repository) : super(repository);
}

abstract class ICounterStoreTotal extends ChangeNotifier {
  int get value;
  void reset();
}

class CounterStoreTotal extends ICounterStoreTotal {
  final List<ICounterStore> stores;

  CounterStoreTotal(this.stores) {
    for (var store in stores) {
      store.addListener(() => notifyListeners());
    }
  }

  @override
  int get value => stores.map((e) => e.value).reduce((value, element) => value + element);

  @override
  void reset() {
    for (var store in stores) {
      store.reset();
    }
  }
}
