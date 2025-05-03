import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smartconsultor/features/dashboard/presentation/pages/dashboard.dart';
import 'package:smartconsultor/core/di/injection_container.dart' as di;

import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const LOGIN_ROUTE = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            isDarkTheme
                ? 'images/auth-background_dark.png'
                : 'images/auth-background.png',
            fit: BoxFit.cover,
            //width: double.infinity,
            //height: double.infinity,
          ),
          // Content
          Center(
            child: BlocProvider(
              create: (context) => di.sl<LoginBloc>(),
              child: const LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => di.sl<LoginBloc>(),
        child: Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacementNamed(
                      context, Dashboard.DASHBOARD_ROUTE);
                } else if (state is LoginError) {
                  Navigator.pushReplacementNamed(
                      context, LoginPage.LOGIN_ROUTE);
                } else if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.pushReplacementNamed(
                      context, LoginPage.LOGIN_ROUTE);
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Image.network(
                                    'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                                    height: 32),
                                const SizedBox(width: 8),
                                const Text(
                                  'FireAnt',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Trang chủ',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search)),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<LoginBloc>().add(PerformLogin());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text('Đăng nhập'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTab('Phần mềm', true),
                            _buildTab('Đầu tư', false),
                            _buildTab('Bảo hiểm', false),
                            _buildTab('Khác', false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Phần mềm FireAnt',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Trên ',
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                        text: '3 triệu',
                                        style: TextStyle(
                                            color: Colors.pinkAccent)),
                                    TextSpan(text: ' người đã sử dụng'),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Mua dịch vụ'),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Main content box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPlatformItem(
                                      Icons.desktop_windows,
                                      'Web - PC',
                                      'Nền tảng phân tích hỗ trợ đầu tư trên máy tính'),
                                  _buildPlatformItem(Icons.smartphone, 'Mobile',
                                      'Theo dõi thông tin, đầu tư trên điện thoại'),
                                  _buildPlatformItem(
                                      Icons.bar_chart,
                                      'AmiBroker',
                                      'Dữ liệu cho AmiBroker, MetaStock'),
                                  _buildPlatformItem(Icons.table_chart, 'Excel',
                                      'Khai thác, phân tích dữ liệu trên Excel'),
                                  _buildPlatformItem(
                                      Icons.insert_chart,
                                      'Infographic',
                                      'Lập báo cáo phân tích với dữ liệu cập nhật nhất'),
                                  _buildPlatformItem(
                                      Icons.smart_toy,
                                      'AI Copilot',
                                      'Trợ lý AI dành riêng cho nhà đầu tư chứng khoán',
                                      isNew: true),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Right Column
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nền tảng phân tích, công cụ đầu tư chứng khoán trên máy tính',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: const [
                                      Chip(label: Text('Công nghệ hiện đại')),
                                      Chip(
                                          label: Text(
                                              'Tùy biến giao diện linh hoạt')),
                                      Chip(
                                          label: Text(
                                              'Phân tích kỹ thuật nhiều biểu đồ')),
                                      Chip(
                                          label: Text(
                                              'Tin tức đa chiều, cập nhật liên tục')),
                                      Chip(
                                          label: Text(
                                              'Cộng đồng sôi nổi, nhiều chuyên gia')),
                                      Chip(
                                          label: Text(
                                              'Các công cụ phân tích, tìm kiếm cơ hội')),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Truy cập ngay'),
                                      ),
                                      const SizedBox(width: 12),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('Bản cũ'),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }

  Widget _buildTab(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildPlatformItem(IconData icon, String title, String subtitle,
      {bool isNew = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (isNew)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4)),
                        child:
                            const Text('NEW', style: TextStyle(fontSize: 10)),
                      )
                  ],
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }
}
