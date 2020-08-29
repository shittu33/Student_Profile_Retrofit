import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollapseAppBar extends StatelessWidget {
  const CollapseAppBar({
    Key key,
    this.expandedHeight,
    this.leading,
    this.actions,
    this.centerTitle,
    this.title,
    this.background,
  }) : super(key: key);

  final double expandedHeight;
  final Icon leading;
  final List<Widget> actions;
  final bool centerTitle;
  final Text title;
  final Image background;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight != null ? expandedHeight : 250,
      floating: false,
      pinned: true,
      leading: leading != null ? leading : null,
      actions: leading != null ? actions : null,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: centerTitle != null ? centerTitle : false,
        title: title != null ? title : null,
        background: background != null ? background : Image.asset(""),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  TabWidget(
      {Key key,
      @required this.tabsList,
      this.unselectedColor,
      this.selectedColor,
      this.initial,
      this.ontap})
      : super(key: key);

  final List<Tab> tabsList;
  final Color unselectedColor;
  final Color selectedColor;
  int initial = 0;
  Function(int pos) ontap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
//      initialIndex: initial==0?0:initial,
      length: tabsList.length,
      child: SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            TabBar(
                onTap: ontap,
                unselectedLabelColor: unselectedColor,
                labelColor: selectedColor,
                tabs: tabsList),
          )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: new Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
