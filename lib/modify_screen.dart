import 'package:flutter/material.dart';

import 'mortgage.dart';

// Second screen - lets the user change the years, amount, and interest rate
class ModifyScreen extends StatefulWidget {
  final Mortgage mortgage;

  const ModifyScreen({super.key, required this.mortgage});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  int years = 30;
  double selectedRate = 3.5;
  TextEditingController amountController = TextEditingController();
  List<double> rates = [];

  @override
  void initState() {
    super.initState();

    // make the list of rates: 2.00, 2.25, 2.50 ... 15.00
    for (double r = 2.0; r <= 15.0; r = r + 0.25) {
      rates.add(r);
    }

    // start with the values from the first screen
    years = widget.mortgage.getYears();
    amountController.text = widget.mortgage.getAmount().toStringAsFixed(2);

    // the rate is saved as 0.035, so times 100 to get 3.5
    // (rounded to 2 decimals so it matches a number in the list)
    selectedRate = double.parse(
      (widget.mortgage.getRate() * 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void donePressed() {
    double? amount = double.tryParse(amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    Mortgage newMortgage = Mortgage();
    newMortgage.setAmount(amount);
    newMortgage.setYears(years);
    newMortgage.setRate(selectedRate / 100);

    // send the new mortgage back to the first screen
    Navigator.pop(context, newMortgage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Loan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Years',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioGroup<int>(
              groupValue: years,
              onChanged: (value) {
                setState(() {
                  years = value!;
                });
              },
              child: const Row(
                children: [
                  Radio<int>(value: 10),
                  Text('10'),
                  Radio<int>(value: 15),
                  Text('15'),
                  Radio<int>(value: 30),
                  Text('30'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Interest Rate: ${selectedRate.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // list of interest rates
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListView.builder(
                  itemCount: rates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${rates[index].toStringAsFixed(2)}%'),
                      selected: rates[index] == selectedRate,
                      selectedTileColor: Colors.teal[50],
                      trailing: rates[index] == selectedRate
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedRate = rates[index];
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: donePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
