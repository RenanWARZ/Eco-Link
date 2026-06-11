import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'complaint_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'map_screen.dart';
import 'points_screen.dart';
import 'schedule_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titles = ['EcoLink', 'Mapa', 'Agendamento', 'Denúncia', 'Pontuação'];

  void _navigateTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onNavigateTab: _navigateTab),
      const MapScreen(),
      const ScheduleScreen(),
      const ComplaintScreen(),
      const PointsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _navigateTab,
        items: const [
          BottomNavigationBarItem(icon: Text('🏠', style: TextStyle(fontSize: 20)), label: 'Home'),
          BottomNavigationBarItem(icon: Text('📍', style: TextStyle(fontSize: 20)), label: 'Mapa'),
          BottomNavigationBarItem(icon: Text('📅', style: TextStyle(fontSize: 20)), label: 'Agendar'),
          BottomNavigationBarItem(icon: Text('🚨', style: TextStyle(fontSize: 20)), label: 'Denúncia'),
          BottomNavigationBarItem(icon: Text('⭐', style: TextStyle(fontSize: 20)), label: 'Pontos'),
        ],
      ),
    );
  }
}
