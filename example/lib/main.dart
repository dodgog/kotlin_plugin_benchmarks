import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:kotlin_plugin/kotlin_bindings.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';

JObject activity = JObject.fromReference(Jni.getCurrentActivity());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  // await optimizeDatabaseSettings(database);
  await database.resetDatabase();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  const MyApp(this.database, {super.key});

  final AppDatabase database;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(database, title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.database, {super.key, required this.title});

  final AppDatabase database;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DatabaseJniHelper helper;
  late final EventsQueries delightQueries;
  String _driftBenchmarkResult = '';
  String _kotlinBenchmarkResult = '';
  String _jniBenchmarkResult = '';
  String _bulkBenchmarkResult = '';
  double _logEntityCount = 2.0; // Default to 100 (10^2)

  int get _entityCount => math.pow(10, _logEntityCount).round();

  @override
  void initState() {
    super.initState();
    helper = DatabaseJniHelper(activity);
    // final sqlDriver = helper.
    delightQueries = helper.getEventsQueries();
  }

  @override
  void dispose() {
    super.dispose();
    helper.release();
    delightQueries.release();
  }

  Future<String> benchmarkKotlinEventInsertsAndSelects({
    int countOfEntities = 100,
  }) async {
    final result =
        helper.benchmarkEventInsertsAndSelects(countOfEntities).toDartString();
    return result;
  }

  Future<String> benchmarkSqlDelightJNIEventInsertsAndSelects({
    int countOfEntities = 100,
  }) async {
    const eventsPerEntity = 5;
    const trials = 100;
    // Clear existing data

    delightQueries.resetDatabase();

    // Generate entity_ids
    final entityIds = List.generate(
      (countOfEntities + trials / eventsPerEntity).floor(),
      (index) => 'entity_$index',
    );

    // First insert countOfEntities events without timing
    for (int i = 0; i < countOfEntities; i++) {
      delightQueries.insertEvent(
        // const Uuid().v4().toJString(),
        math.Random().nextInt(1000000000).toString().toJString(),
        entityIds[math.Random().nextInt(entityIds.length)].toJString(),
        'test_attr'.toJString(),
        'test_value'.toJString(),
        DateTime.now().toIso8601String().toJString(),
      );
    }

    // Now perform trials number of timed inserts
    final insertTimes = <int>[];
    for (int i = 0; i < trials; i++) {
      final stopwatch = Stopwatch()..start();
      delightQueries.insertEvent(
        math.Random().nextInt(1000000000).toString().toJString(),
        // const Uuid().v4().toJString(),
        entityIds[math.Random().nextInt(entityIds.length)].toJString(),
        'test_attr'.toJString(),
        'test_value'.toJString(),
        DateTime.now().toIso8601String().toJString(),
      );
      stopwatch.stop();
      insertTimes.add(stopwatch.elapsedMicroseconds);
    }

    // Measure select performance
    final selectTimes = <int>[];

    // Perform trials number of select queries
    for (int i = 0; i < trials; i++) {
      final entityId = entityIds[math.Random().nextInt(entityIds.length)];
      final stopwatch = Stopwatch()..start();
      final query = delightQueries.getEventByEntityId$1(entityId.toJString());
      final result = helper.execQuery(query);
      result.map(
          (e) => (e.getId().toDartString(), e.getEntity_id().toDartString()));
      // print(result);
      // query.
      stopwatch.stop();
      // print(result);
      selectTimes.add(stopwatch.elapsedMicroseconds);
    }

    final avgInsertTime =
        insertTimes.reduce((a, b) => a + b) / insertTimes.length;
    final avgSelectTime =
        selectTimes.reduce((a, b) => a + b) / selectTimes.length;
    return 'Average insert time (timer): ${avgInsertTime.toStringAsFixed(2)} microseconds\nAverage select time (timer): ${avgSelectTime.toStringAsFixed(2)} microseconds';
  }

  Future<String> benchmarkDriftEventInsertsAndSelects({
    int countOfEntities = 100,
  }) async {
    const eventsPerEntity = 5;
    const trials = 100;
    // Clear existing data
    await widget.database.resetDatabase();

    // Generate entity_ids
    final entityIds = List.generate(
      (countOfEntities + trials / eventsPerEntity).floor(),
      (index) => 'entity_$index',
    );

    // First insert countOfEntities events without timing
    for (int i = 0; i < countOfEntities; i++) {
      await widget.database.insertEvent(
        // const Uuid().v4(),
        math.Random().nextInt(1000000000).toString(),
        entityIds[math.Random().nextInt(entityIds.length)],
        'test_attr',
        'test_value',
        DateTime.now().toIso8601String(),
      );
    }

    // Now perform trials number of timed inserts
    final insertTimes = <int>[];
    for (int i = 0; i < trials; i++) {
      final stopwatch = Stopwatch()..start();
      await widget.database.insertEvent(
        // const Uuid().v4(),
        math.Random().nextInt(1000000000).toString(),
        entityIds[math.Random().nextInt(entityIds.length)],
        'test_attr',
        'test_value',
        DateTime.now().toIso8601String(),
      );
      stopwatch.stop();
      insertTimes.add(stopwatch.elapsedMicroseconds);
    }

    // Measure select performance
    final selectTimes = <int>[];

    // Perform trials number of select queries
    for (int i = 0; i < trials; i++) {
      final entityId = entityIds[math.Random().nextInt(entityIds.length)];
      final stopwatch = Stopwatch()..start();
      await widget.database.getEventByEntityId(entityId).get();
      stopwatch.stop();
      selectTimes.add(stopwatch.elapsedMicroseconds);
    }

    final avgInsertTime =
        insertTimes.reduce((a, b) => a + b) / insertTimes.length;
    final avgSelectTime =
        selectTimes.reduce((a, b) => a + b) / selectTimes.length;
    return 'Average insert time (timer): ${avgInsertTime.toStringAsFixed(2)} microseconds\nAverage select time (timer): ${avgSelectTime.toStringAsFixed(2)} microseconds';
  }

  Future<String> bulkBenchmarkDriftEventInsertsAndSelects({
    int countOfEntities = 100,
  }) async {
    const eventsPerEntity = 5;
    const trials = 100;
    // Clear existing data
    await widget.database.resetDatabase();

    // Generate entity_ids
    final entityIds = List.generate(
      (countOfEntities + trials / eventsPerEntity).floor(),
      (index) => 'entity_$index',
    );

    // First insert countOfEntities events without timing
    await widget.database.transaction(() async {
      for (int i = 0; i < countOfEntities; i++) {
        await widget.database.insertEvent(
          // const Uuid().v4(),
          math.Random().nextInt(1000000000).toString(),
          entityIds[math.Random().nextInt(entityIds.length)],
          'test_attr',
          'test_value',
          DateTime.now().toIso8601String(),
        );
      }
    });

    // Now perform trials number of timed inserts
    final stopwatch1 = Stopwatch()..start();
    await widget.database.transaction(() async {
      for (int i = 0; i < trials; i++) {
        await widget.database.insertEvent(
          // const Uuid().v4(),
          math.Random().nextInt(1000000000).toString(),
          entityIds[math.Random().nextInt(entityIds.length)],
          'test_attr',
          'test_value',
          DateTime.now().toIso8601String(),
        );
      }
    });
    stopwatch1.stop();
    final insertTime = (stopwatch1.elapsedMicroseconds);

    // Perform trials number of select queries

    final stopwatch2 = Stopwatch()..start();
    await widget.database.transaction(() async {
      for (int i = 0; i < trials; i++) {
        final entityId = entityIds[math.Random().nextInt(entityIds.length)];
        await widget.database.getEventByEntityId(entityId).get();
      }
    });
    stopwatch2.stop();
    final selectTime = stopwatch2.elapsedMicroseconds;

    final avgInsertTime = insertTime / trials;
    final avgSelectTime = selectTime / trials;
    return 'Average insert time (timer): ${avgInsertTime.toStringAsFixed(2)} microseconds\nAverage select time (timer): ${avgSelectTime.toStringAsFixed(2)} microseconds';
  }

  Future<void> runDriftBenchmarks() async {
    setState(() {
      _driftBenchmarkResult =
          'Running benchmarks with $_entityCount entities...';
    });

    await widget.database.resetDatabase();
    final result = await benchmarkDriftEventInsertsAndSelects(
      countOfEntities: _entityCount,
    );

    setState(() {
      _driftBenchmarkResult = result;
    });
  }

  Future<void> runKotlinBenchmarks() async {
    setState(() {
      _kotlinBenchmarkResult =
          'Running Kotlin benchmarks with $_entityCount entities...';
    });

    final result = await benchmarkKotlinEventInsertsAndSelects(
      countOfEntities: _entityCount,
    );

    setState(() {
      _kotlinBenchmarkResult = result;
    });
  }

  Future<void> runJNIBenchmarks() async {
    setState(() {
      _jniBenchmarkResult =
          'Running SQLDelight benchmarks with $_entityCount entities...';
    });

    final result = await benchmarkSqlDelightJNIEventInsertsAndSelects(
      countOfEntities: _entityCount,
    );

    setState(() {
      _jniBenchmarkResult = result;
    });
  }

  Future<void> runBulkDriftBenchmarks() async {
    setState(() {
      _bulkBenchmarkResult =
          'Running bulk benchmarks with $_entityCount entities...';
    });

    final result = await bulkBenchmarkDriftEventInsertsAndSelects(
      countOfEntities: _entityCount,
    );

    setState(() {
      _bulkBenchmarkResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Entity Count: '),
                Text(
                  '$_entityCount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Slider(
              min: 0.0,
              max: 4.0,
              divisions: 4,
              value: _logEntityCount,
              label: '$_entityCount entities',
              onChanged: (value) {
                setState(() {
                  _logEntityCount = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: runDriftBenchmarks,
                  child: const Text('Run Drift Benchmarks'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: runKotlinBenchmarks,
                  child: const Text('Run Kotlin Benchmarks'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: runJNIBenchmarks,
                  child: const Text('Run JNI Benchmarks'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: runBulkDriftBenchmarks,
                  child: const Text('Run Bulk Drift Benchmarks'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Drift Benchmark Results',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_driftBenchmarkResult, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Kotlin Benchmark Results',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_kotlinBenchmarkResult, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'JNI Benchmark Results',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_jniBenchmarkResult, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Bulk Benchmark Results',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_bulkBenchmarkResult, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> optimizeDatabaseSettings(AppDatabase database) async {
  await database.customStatement(
    'PRAGMA journal_mode=WAL',
  ); // Write-Ahead Logging
  await database.customStatement(
    'PRAGMA synchronous=NORMAL',
  ); // Less strict durability
  await database.customStatement(
    'PRAGMA cache_size=10000',
  ); // Increase cache size
  await database.customStatement(
    'PRAGMA temp_store=MEMORY',
  ); // Store temp tables and indices in memory
  await database.customStatement(
    'PRAGMA mmap_size=30000000000',
  ); // Allow memory-mapped I/O
  await database.customStatement(
    'PRAGMA page_size=4096',
  ); // Optimal page size for most systems
}
