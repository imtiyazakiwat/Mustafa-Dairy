import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculationPage(),
  ));
}

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  double litres = 1;
  TextEditingController snfController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController farmerNameController = TextEditingController();
  TextEditingController balanceController = TextEditingController(); // Added balance controller
  DateTime? selectedDate;
  List<DateTime> previousDates = [];
  List<double> morningLitres = List.filled(7, 0.0);
  List<double> morningSNF = List.filled(7, 0.0);
  List<double> morningFat = List.filled(7, 0.0);
  List<double> eveningLitres = List.filled(7, 0.0);
  List<double> eveningSNF = List.filled(7, 0.0);
  List<double> eveningFat = List.filled(7, 0.0);
  double totalMorningLitres = 0;
  double totalEveningLitres = 0;
  double totalLitres = 0;
  double totalMorningAmount = 0;
  double totalEveningAmount = 0;
  double totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Bill Date: '),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Farmer Name: '),
                Expanded(
                  child: TextField(
                    controller: farmerNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter farmer name',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSection("Morning", morningLitres, morningSNF, morningFat, totalMorningLitres, totalMorningAmount),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildSection("Evening", eveningLitres, eveningSNF, eveningFat, totalEveningLitres, totalEveningAmount),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Litres: $totalLitres',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Text('Balance: '),
                            Expanded(
                              child: TextField(
                                controller: balanceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Balance',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Total Amount: ${totalAmount.toStringAsFixed(2)}', // Formatting total amount to two decimal places
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<double> litres, List<double> snf, List<double> fat, double totalLitres, double totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              TableCell(child: Center(child: Text(title == 'Morning' ? 'Date' : 'Date'))),
              TableCell(child: Center(child: Text('Litres'))),
              TableCell(child: Center(child: Text('Fat'))),
              TableCell(child: Center(child: Text('SNF'))),
              TableCell(child: Center(child: Text('Total Amount'))),
            ]),
            for (int i = 0; i < 7; i++)
              TableRow(children: [
                TableCell(
                  child: Center(
                    child: Text(previousDates.length > i ? '${previousDates[i].day}/${previousDates[i].month}' : ''),
                  ),
                ),
                TableCell(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      litres[i] = double.tryParse(value) ?? 0.0;
                      calculateTotals();
                    },
                  ),
                ),
                TableCell(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      fat[i] = double.tryParse(value) ?? 0.0;
                      calculateTotals();
                    },
                  ),
                ),
                TableCell(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      snf[i] = double.tryParse(value) ?? 0.0;
                      calculateTotals();
                    },
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text((litres[i] * calcAmount(fat[i], snf[i])).toStringAsFixed(2)),
                  ),
                ),
              ]),
            TableRow(children: [
              TableCell(child: SizedBox()),
              TableCell(child: SizedBox()),
              TableCell(child: SizedBox()),
              TableCell(child: SizedBox()),
              TableCell(child: SizedBox()),
            ]),
            TableRow(children: [
              TableCell(child: Center(child: Text('Total'))),
              TableCell(child: Center(child: Text(totalLitres.toStringAsFixed(2)))),
              TableCell(child: SizedBox()),
              TableCell(child: SizedBox()),
              TableCell(child: Center(child: Text(totalAmount.toStringAsFixed(2)))),
            ]),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _generatePreviousDates();
      });
    }
  }

  void _generatePreviousDates() {
    previousDates.clear();
    if (selectedDate != null) {
      for (int i = 6; i >= 0; i--) {
        previousDates.add(selectedDate!.subtract(Duration(days: i)));
      }
    }
  }

  void calculateTotals() {
    setState(() {
      totalMorningLitres = morningLitres.reduce((value, element) => value + element);
      totalEveningLitres = eveningLitres.reduce((value, element) => value + element);
      totalLitres = totalMorningLitres + totalEveningLitres;

      totalMorningAmount = 0;
      totalEveningAmount = 0;
      for (int i = 0; i < 7; i++) {
        totalMorningAmount += morningLitres[i] * calcAmount(morningFat[i], morningSNF[i]);
        totalEveningAmount += eveningLitres[i] * calcAmount(eveningFat[i], eveningSNF[i]);
      }

      totalAmount = totalMorningAmount + totalEveningAmount;
    });
  }

  double calcAmount(double fat, double snf) {
    double s = 9.0;
    double sp = (snf - s) * 10;

    double sa = snf <= 9.0 ? sp * 0.50 : sp * 0.05;

    double f = 6.5;
    double fp = (fat - f) * 10;
    double fa = fat <= 6.5 ? fp * 0.50 : fp * 0.60;

    double amount = sa + fa + 52;
    return amount;
  }
}
