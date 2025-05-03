import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isCollapsed = false;

  void toggleCollapse() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = isCollapsed ? 72 : 240;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: sidebarWidth,
      decoration: const BoxDecoration(
        color: Color(0xFF254E70),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Replacing DrawerHeader with SizedBox for custom height control
          SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (!isCollapsed)
                    const Expanded(
                      child: Text(
                        "Expense Tracker",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: toggleCollapse,
                    tooltip: isCollapsed ? "Mở rộng" : "Thu gọn",
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Colors.white.withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),
          ),

          const SizedBox(height: 8),

          buildNavItem(Icons.dashboard, "Dashboard"),
          buildNavItem(Icons.swap_horiz, "Transactions"),
          buildNavItem(Icons.pie_chart, "Budget"),
          buildNavItem(Icons.savings, "Savings"),
          const Spacer(),
          buildNavItem(Icons.settings, "Settings"),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        // Placeholder: thêm xử lý nếu cần
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (!isCollapsed) const SizedBox(width: 12),
            if (!isCollapsed)
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
