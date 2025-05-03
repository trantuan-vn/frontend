import 'package:flutter/material.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    const cards = [
      _CardItem(
        title: "Balance",
        amount: "\$10,940",
        color: Colors.purple,
        icon: Icons.account_balance_wallet,
      ),
      _CardItem(
        title: "Income",
        amount: "\$12,500",
        color: Colors.green,
        icon: Icons.attach_money,
      ),
      _CardItem(
        title: "Expense",
        amount: "\$1,560",
        color: Colors.red,
        icon: Icons.money_off,
      ),
      _CardItem(
        title: "Savings",
        amount: "\$25,250",
        color: Colors.blue,
        icon: Icons.savings,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        const minCardWidth = 160.0;
        final maxWidth = constraints.maxWidth;

        // Tính số card có thể hiển thị trong 1 hàng mà không bị tràn
        int cardsPerRow = (maxWidth / (minCardWidth + spacing)).floor();
        cardsPerRow = cardsPerRow.clamp(1, cards.length);

        // Tính lại card width cho phù hợp
        double availableWidth = maxWidth - (cardsPerRow - 1) * spacing;
        double cardWidth = availableWidth / cardsPerRow;

        // Nếu đủ chỗ cho tất cả cards: dùng Row với spaceBetween
        if (cardsPerRow >= cards.length) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cards
                .map((card) => SizedBox(width: cardWidth, child: card))
                .toList(),
          );
        } else {
          // Nếu không đủ chỗ: cuộn ngang với kích thước card hợp lý
          return SizedBox(
            height: 160,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cards
                    .map((card) => Padding(
                          padding: const EdgeInsets.only(right: spacing),
                          child: SizedBox(width: minCardWidth, child: card),
                        ))
                    .toList(),
              ),
            ),
          );
        }
      },
    );
  }
}

class _CardItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _CardItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
