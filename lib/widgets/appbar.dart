import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';

class ApplicationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationAppBar({Key? key, required this.title, this.acts, this.tabs})
      : super(key: key);

  final String title;
  final List<Widget>? acts;
  final List<Tab>? tabs;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/MoroccanKingdom.png',
        width: 40,
        height: 40,
      ),
      centerTitle: true,
      actions: [
        if (acts != null) ...acts!.map((act) => act).toList(),
        Center(
            child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        )),
        const SizedBox(
          width: 10,
        ),
        
      ],
      elevation: 0.0,
      bottom: tabs != null
          ? TabBar(
              tabs: tabs!.map((tab) => tab).toList(),
              indicatorColor: Style.secondaryColor,
              indicatorSize: TabBarIndicatorSize.label,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => tabs != null
      ? AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'dd',
              )
            ],
          ),
        ).preferredSize
      : AppBar().preferredSize;
}
