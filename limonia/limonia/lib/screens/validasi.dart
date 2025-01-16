import 'package:flutter/material.dart';
import 'package:limonia/screens/splash_screen.dart';

class ValidasiPage extends StatefulWidget {
  @override
  _ValidasiPageState createState() => _ValidasiPageState();
}

class _ValidasiPageState extends State<ValidasiPage> {
  final TextEditingController _controller = TextEditingController();

  void _navigateToNextPage() async {
    final inputText = _controller.text;
    await storage.write(key: 'url', value: inputText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validasi Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukan URL Ngrok',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToNextPage,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final String input;

  const NextPage({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text(
          'You entered: $input',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
