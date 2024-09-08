
import 'package:flutter/material.dart';
import 'package:smartconsultor/features/dashboard/presentation/widgets/block_wrapper.dart';
import 'package:smartconsultor/features/dashboard/presentation/widgets/footer.dart';
import 'package:smartconsultor/features/dashboard/presentation/widgets/get_started.dart';
import 'package:smartconsultor/features/dashboard/presentation/widgets/web_site_menu_bar.dart';

class Dashboard extends StatelessWidget { 
  // ignore: constant_identifier_names
  static const DASHBOARD_ROUTE = '/dashboard'; 

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size(double.infinity, 66), child: WebsiteMenuBar()),
        body: ListView.builder(
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              return blocks[index];
            }),
      );
  }
}

List<Widget> blocks = [
    const BlockWrapper(GetStarted()),
    const Footer(),
];