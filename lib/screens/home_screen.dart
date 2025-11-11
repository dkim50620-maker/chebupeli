import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  bool _isLoading = true; // чтобы не показывать 0 пока не загрузили

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// Загружаем значение счётчика из SharedPreferences
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCounter = prefs.getInt('counter') ?? 0;
    setState(() {
      _counter = savedCounter;
      _isLoading = false;
    });
  }

  /// Сохраняем значение счётчика
  Future<void> _saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', value);
  }

  void _incrementCounter() async {
    final newValue = _counter + 1;
    setState(() {
      _counter = newValue;
    });
    await _saveCounter(newValue); // сохраняем после обновления
  }

  void _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('counter');
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моё приложение'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Сбросить счётчик',
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // пока загружаем
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Вы нажали кнопку столько раз:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Значение сохраняется даже после перезапуска приложения!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
