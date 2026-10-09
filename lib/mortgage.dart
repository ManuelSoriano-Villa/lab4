import 'dart:math';

// Mortgage class from the lab handout, written in Dart
class Mortgage {
  double _amount = 0;
  int _years = 0;
  double _rate = 0;

  Mortgage() {
    setAmount(100000.0);
    setYears(30);
    setRate(0.035);
  }

  void setAmount(double newAmount) {
    if (newAmount >= 0) {
      _amount = newAmount;
    }
  }

  void setYears(int newYears) {
    if (newYears >= 0) {
      _years = newYears;
    }
  }

  void setRate(double newRate) {
    if (newRate >= 0) {
      _rate = newRate;
    }
  }

  double getAmount() {
    return _amount;
  }

  String getFormattedAmount() {
    return '\$${_amount.toStringAsFixed(2)}';
  }

  int getYears() {
    return _years;
  }

  double getRate() {
    return _rate;
  }

  double monthlyPayment() {
    double mRate = _rate / 12; // monthly interest rate
    double temp = pow(1 / (1 + mRate), _years * 12).toDouble();
    return _amount * mRate / (1 - temp);
  }

  String formattedMonthlyPayment() {
    return '\$${monthlyPayment().toStringAsFixed(2)}';
  }

  double totalPayment() {
    return monthlyPayment() * _years * 12;
  }

  String formattedTotalPayment() {
    return '\$${totalPayment().toStringAsFixed(2)}';
  }
}
