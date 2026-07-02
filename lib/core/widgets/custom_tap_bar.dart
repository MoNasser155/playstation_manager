import 'package:flutter/material.dart';

class CustomTapBar extends StatefulWidget {
  const CustomTapBar({
    super.key,
    required this.tapsTitle,
    this.onTap,
    this.isAbsorbPointer = false,
    this.tabAlignment,
    this.isScrollable = true,
    this.initialIndex,
  });

  final List<String> tapsTitle;
  final void Function(int)? onTap;
  final bool isAbsorbPointer, isScrollable;
  final TabAlignment? tabAlignment;
  final int? initialIndex;

  @override
  State<CustomTapBar> createState() => _CustomTapBarState();
}

class _CustomTapBarState extends State<CustomTapBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tapsTitle.length,
      vsync: this,
      initialIndex: widget.initialIndex ?? 0,
    );
  }

  @override
  void didUpdateWidget(CustomTapBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync the tab controller when initialIndex changes externally (e.g. after refresh)
    final newIndex = widget.initialIndex ?? 0;
    if (_tabController.index != newIndex) {
      _tabController.animateTo(newIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isAbsorbPointer,
      child: TabBar(
        controller: _tabController,
        tabAlignment: widget.tabAlignment,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        onTap: widget.onTap,
        isScrollable: widget.isScrollable,
        tabs: widget.tapsTitle.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
