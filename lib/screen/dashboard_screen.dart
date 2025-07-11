import 'package:buy_and_sell/screen/home_screen.dart';
import 'package:buy_and_sell/screen/my_product_list.dart';
import 'package:buy_and_sell/screen/profile_screen.dart';
import 'package:buy_and_sell/screen/watch_list_screen.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    WatchListScreen(),
    MyProductList(),
    ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _currentIndex == 0 ? const Color.fromARGB(255, 242, 139, 5) : Color.fromARGB(255, 231, 177, 29),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp, color: _currentIndex == 1 ? const Color.fromARGB(255, 242, 139, 5): Color.fromARGB(255, 231, 177, 29),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits,color: _currentIndex == 2 ? const Color.fromARGB(255, 242, 139, 5): Color.fromARGB(255, 231, 177, 29),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: _currentIndex == 3 ? const Color.fromARGB(255, 242, 139, 5): Color.fromARGB(255, 231, 177, 29),),
            label: '',
          ),
        ],
      ),
    );
  }
}
