import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/features/home/data/model/navigation_tab_model.dart';

class BottomNavigationWidget extends StatelessWidget {
  final NavigationTab selectedTab;
  final Function(int) onTabChanged;

  const BottomNavigationWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.only(bottom:Platform.isIOS? 26:8),
      decoration: const BoxDecoration(
        color: Color(0xff060826),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: NavigationTab.values.map((tab) {
          return _buildNavItem(
            tab.label,
            tab.iconPath,
            selectedTab == tab,
            tab.tabIndex,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(String label, String icon, bool isActive, int index) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onTabChanged(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: SvgPicture.asset(
              icon,
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
