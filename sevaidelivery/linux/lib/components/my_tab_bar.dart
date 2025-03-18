import 'package:flutter/material.dart';

import '../models/food.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  MyTabBar({required this.tabController});

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) => Tab(text: category.toString().split('.').last)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: _buildCategoryTabs(),
    );
  }
}
