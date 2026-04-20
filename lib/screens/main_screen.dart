import 'package:flutter/material.dart';

// import screen kamu
import 'home/home.dart';
import 'upload/upload.dart';
import 'history/history.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const MainScreen({super.key, required this.onToggleTheme});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> _titles = ["Home", "Upload", "History"];
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeView(onToggleTheme: widget.onToggleTheme),
      const UploadView(),
      const HistoryView(),
    ];
  }

  // 🔥 TAMBAHAN INI
  List<Widget> _buildActions() {
    switch (_currentIndex) {
      case 0: // Home
        return [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ];

      case 1: // Upload
        return [];

      case 2: // History
        return [];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // 🔥 biar kita kontrol padding sendiri
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(_titles[_currentIndex]),
        ),

        // 🔥 PASANG DI SINI
        actions: _buildActions(),
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).disabledColor,

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_rounded),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), // 🔥 sekalian benerin
            label: "History",
          ),
        ],
      ),
    );
  }
}
