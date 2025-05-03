import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Builder(
          builder: (context) {
            return GestureDetector(
              onTapDown: (TapDownDetails details) async {
                // Calculate the position for the menu based on tap details
                final position = details.globalPosition;
                final size = details.localPosition;

                final result = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    position.dx,
                    position.dy,
                    position.dx + size.dx,
                    position.dy + 200, // Adjust as needed for menu height
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 'Transaction',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, color: Colors.black54),
                          SizedBox(width: 8),
                          Text('Transaction'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Budget',
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.black54),
                          SizedBox(width: 8),
                          Text('Budget'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Savings',
                      child: Row(
                        children: [
                          Icon(Icons.savings, color: Colors.black54),
                          SizedBox(width: 8),
                          Text('Savings'),
                        ],
                      ),
                    ),
                  ],
                );

                if (!context.mounted) return;

                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: $result")),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Create", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        const CircleAvatar(child: Text("TT")),
      ],
    );
  }
}
