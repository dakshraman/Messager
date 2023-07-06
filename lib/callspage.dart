import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  _CallsPageState createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  List<String> callItems = [
    'John Doe',
    'Jane Smith',
    'Mark Johnson',
    // Add more call items as needed
  ];

  List<String> filteredItems = [];

  int _currentSegment = 0;

  @override
  void initState() {
    super.initState();
    filteredItems.addAll(callItems);
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = callItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onValueChanged(int? value) {
    setState(() {
      _currentSegment = value ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            middle: CupertinoSlidingSegmentedControl(
              backgroundColor: Colors.grey.shade900,
              thumbColor: Colors.grey.shade700,
              onValueChanged: _onValueChanged,
              children: const {
                0: Text('All',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                1: Text('Missed',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              },
              groupValue: _currentSegment,
            ),
            backgroundColor: Colors.black,
            largeTitle: Text('Calls',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverToBoxAdapter(
              child: CupertinoSearchTextField(
                onChanged: _filterItems,
                placeholder: 'Search',
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = filteredItems[index];
                return _buildCallItem(
                  item,
                  'Incoming',
                  'Yesterday, 10:00 AM',
                  CupertinoIcons.phone_fill_arrow_down_left,
                  CupertinoColors.systemGreen,
                );
              },
              childCount: filteredItems.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallItem(
      String name,
      String type,
      String timestamp,
      IconData icon,
      Color iconColor,
      ) {
    return Material(
      color: Colors.grey.shade900,
      child: CupertinoListTile.notched(
        leading: CircleAvatar(
          child: Icon(CupertinoIcons.person),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          type,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              timestamp,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle call item tap
        },
      ),
    );
  }
}
