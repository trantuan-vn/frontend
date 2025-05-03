import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        "title": "Transportation",
        "subtitle": "Gas refill",
        "amount": "-\$80",
        "date": "8/10/2024"
      },
      {
        "title": "Utilities",
        "subtitle": "Water bill",
        "amount": "-\$50",
        "date": "9/15/2024"
      },
      {
        "title": "Entertainment",
        "subtitle": "Movie night",
        "amount": "-\$60",
        "date": "10/20/2024"
      },
      {
        "title": "Healthcare",
        "subtitle": "Doctor visit",
        "amount": "-\$120",
        "date": "11/5/2024"
      },
      {
        "title": "Shopping",
        "subtitle": "Clothing",
        "amount": "-\$250",
        "date": "12/25/2024"
      },
      {
        "title": "Home Maintenance",
        "subtitle": "Plumbing repair",
        "amount": "-\$300",
        "date": "1/30/2025"
      },
      {
        "title": "Education",
        "subtitle": "Online course",
        "amount": "-\$200",
        "date": "2/15/2025"
      },
      {
        "title": "Gifts",
        "subtitle": "Wedding gift",
        "amount": "-\$150",
        "date": "3/1/2025"
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Viewing more transactions...")),
                      );
                    },
                    child: const Text("View More"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, // Đặt chiều cao cụ thể để tránh lỗi trong Column
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(tx['title']![0])),
                    title: Text(tx['title']!),
                    subtitle: Text(tx['subtitle']!),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tx['amount']!,
                            style: const TextStyle(color: Colors.red)),
                        Text(tx['date']!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
