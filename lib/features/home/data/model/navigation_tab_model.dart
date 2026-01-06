enum NavigationTab {
  journey(0, 'Journey', 'assets/icons/journey.svg'),
  chat(1, 'Podcast', 'assets/icons/comment.svg'),
  tribe(2, 'Tribe', 'assets/icons/family-dress.svg'),
  profile(3, 'Profile', 'assets/icons/user.svg');

  const NavigationTab(this.tabIndex, this.label, this.iconPath);

  final int tabIndex;
  final String label;
  final String iconPath;

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.journey,
    );
  }
}
