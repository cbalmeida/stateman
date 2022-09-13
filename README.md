<!-- 
Flutter StateManager is a simple state management and IoC library for Dart and Flutter.
-->

## Description

Flutter StateManager is a simple state management and IoC library for Dart and Flutter.

## Why use it?

- Objects are grouped in single place (container). Enough of getting a crowded context tree when you have many controllers/repos/etc... (like Provider does!)
- Objects are retrieved using an InheritedWidget. That means objects will reside where they should be: in the _Context Tree_ (not in limbo!)
- The object container is built on a Map. So it's lightning fast!


## Usage

Place the `StateManMain` class on the top of the `MaterialApp` and use the `serviceContainerInitializer`
property to create the `StateManServiceContainer` which will contain all the objects you will access later.

You can `register` any object constructor and use `container.resolve<T>()` to retrieve any other instance
of the type `T` from the container.

```dart
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
        ..register((container) => CounterStoreTotal([
          container.resolve<CounterStore1>(),
          container.resolve<CounterStore2>(),
          container.resolve<CounterStore3>(),
        ])),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CountersPage(),
      ),
    );
  }
}
```

To be notified when any `Listenable` object changes in your container use `StateManObserver<T>` (where `T extends Listenable`).
Every time the `Listenable` object is changed, the `StateManObserver` will rebuild the widget tree by calling the `builder(Context context, T yourListenableObject, Widget yourChildWidget)` function.

You can also retrieve any object from the container using `StateManStorage.retrieve<T>(context)` or the container itself using `StateManStorage.container(context)`.


```dart
class CountersPage extends StatelessWidget {
  const CountersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("flutter_stateman")),
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
                StateManStorage.retrieve<CounterStoreTotal>(context).reset();
              },
              backgroundColor: Colors.purpleAccent,
              child: const Icon(Icons.clear),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
```
