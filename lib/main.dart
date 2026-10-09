import 'package:flutter/material.dart';

import 'modify_screen.dart';
import 'mortgage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomeScreen(),
    );
  }
}

// First screen - shows the mortgage info and the payments
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Mortgage mortgage = Mortgage();
  bool termsChecked = false;

  // opens the modify screen and waits for the new data to come back
  void goToModifyScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifyScreen(mortgage: mortgage)),
    );

    // result is null if the user pressed the back arrow instead of Done
    if (result != null) {
      setState(() {
        mortgage = result;
      });
    }
  }

  // shows the alert dialog for the terms and conditions
  void showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const Text(
            'The payments in this app are only estimates. Your real '
            'payment from a lender may be different.\n\n'
            'Do you agree to the terms and conditions?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  termsChecked = false;
                });
                Navigator.pop(context);
              },
              child: const Text('Decline'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  termsChecked = true;
                });
                Navigator.pop(context);
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // loan info
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.attach_money, color: Colors.teal),
                    title: const Text('Amount'),
                    trailing: Text(
                      mortgage.getFormattedAmount(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.teal,
                    ),
                    title: const Text('Years'),
                    trailing: Text(
                      '${mortgage.getYears()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.percent, color: Colors.teal),
                    title: const Text('Interest Rate'),
                    trailing: Text(
                      '${(mortgage.getRate() * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // payments
            Card(
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Payment',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      mortgage.formattedMonthlyPayment(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Total Payment',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      mortgage.formattedTotalPayment(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // terms and conditions check box
            CheckboxListTile(
              title: const Text('Terms and Conditions'),
              value: termsChecked,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                if (value == true) {
                  showTermsDialog();
                } else {
                  setState(() {
                    termsChecked = false;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // the button only works after the terms are accepted
            // (setting onPressed to null makes the button grayed out)
            ElevatedButton(
              onPressed: termsChecked ? goToModifyScreen : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Modify Data', style: TextStyle(fontSize: 18)),
            ),
            if (!termsChecked)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Accept the terms and conditions to modify data',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
