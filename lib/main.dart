import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Menu Demo',
      home: const MenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  // Sample menu items
  List<Map<String, dynamic>> get items => [
    {'name': 'Espresso', 'price': '2.50'},
    {'name': 'Cappuccino', 'price': '3.00'},
    {'name': 'Cheesecake', 'price': '4.50'},
  ];

  @override
  Widget build(BuildContext context) {
    // The URL to encode in QR. For local testing it will be something like "http://localhost:xxxx/"
    final String urlToShare = kIsWeb ? Uri.base.toString() : 'https://example.com/qr-menu';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Menu (Demo)'),
        actions: [
          IconButton(
            tooltip: 'Show QR for this page',
            icon: const Icon(Icons.qr_code),
            onPressed: () => _showQrDialog(context, urlToShare),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Card(
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text('€ ${item['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.qr_code_rounded),
                        onPressed: () {
                          // For each menu item we could encode a link + item id; here we just show page URL
                          _showQrDialog(context, urlToShare + '#item=${Uri.encodeComponent(item['name'])}');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Scan this QR'),
        content: SizedBox(
          width: 250,
          height: 300,
          child: Column(
            children: [
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200,
                gapless: false,
              ),
              const SizedBox(height: 8),
              SelectableText(data, maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      ),
    );
  }
}
