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
  TextEditingController balanceController = TextEditingController();
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
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Mulla Dairy',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blue,
                fontFamily: 'Pacifico',
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Bill Date: '),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: TextStyle(
                      fontSize: selectedDate != null ? 24 : 16,
                      color: selectedDate != null ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('Farmer Name: '),
                Expanded(
                  child: TextField(
                    controller: farmerNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter farmer name',
                    ),
                    style: TextStyle(
                      fontSize: farmerNameController.text.isNotEmpty ? 24 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSection("Morning", morningLitres, morningSNF, morningFat, totalMorningLitres, totalMorningAmount),
                      ),
                      if (!isDesktop) SizedBox(height: 20),
                      if (!isDesktop) SizedBox(height: 20),
                      if (!isDesktop) SizedBox(height: 20),
                      if (!isDesktop) SizedBox(height: 20),
                      if (!isDesktop) SizedBox(height: 20),
                      if (!isDesktop) SizedBox(height: 20),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildSection("Evening", eveningLitres, eveningSNF, eveningFat, totalEveningLitres, totalEveningAmount),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: isDesktop
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Litres: ${totalLitres.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Total Amount: ${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Balance: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: balanceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Balance',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Signature:                                  ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Total Litres: ${totalLitres.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Total Amount: ${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Balance: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Signature: ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(height: 20, thickness: 2),
                SizedBox(height: 20),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // or MainAxisAlignment.spaceAround
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          'Owner Name: Nabisab Mulla',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Mob No: 7259610916',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ],
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
    double baseRate = 23.0;

    // Calculate FAT hike
    double fatHike = 0.0;
    if (fat <= 6.0) {
      int steps = ((fat - 5.0) * 10).floor();
      if (steps > 0) {
        fatHike = List.generate(steps, (i) => 1.5 - 0.1 * i).fold(0, (a, b) => a + b);
      }
    } else if (fat <= 6.5) {
      fatHike = 10.5 + (fat - 6.0) * 5.0;
    } else {
      fatHike = 10.5 + 2.5 + (fat - 6.5) * 3.0;
    }

    // Calculate SNF hike
    double snfHike = 0.0;
    if (snf <= 8.5) {
      snfHike = (snf - 7.5) * 10.0;
    } else if (snf <= 9.0) {
      int steps = ((snf - 8.5) * 10).floor();
      if (steps > 0) {
        snfHike = 10.0 + List.generate(steps, (i) => 0.9 - 0.1 * i).fold(0, (a, b) => a + b);
      } else {
        snfHike = 10.0;
      }
    } else if (snf <= 9.4) {
      snfHike = 10.0 + 3.5;
      if (fat > 5.5) {
        snfHike += 0.1 * (snf - 9.0) * 10;
      }
    } else {
      snfHike = 10.0 + 3.5 + (snf - 9.0) * 1.0;
    }

    // Calculate final amount
    double amount = baseRate + fatHike + snfHike;
    return amount;
  }


}
