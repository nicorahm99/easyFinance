import 'package:date_util/date_util.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<charts.Series<ChartSection, String>> _pieChartData =
      new List<charts.Series<ChartSection, String>>();
  double totalExpense = 0;
  double totalIncome = 0;
  BankbalanceDTO _currentbalance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    _currentbalance = await DBController().getBankbalanceById(1);
    List<TransactionDTO> transactions = await _getTransactionsOfActualMonth();
    transactions.forEach((element) {
      if (element.type == 'income') {
        totalIncome += element.amount;
      } else {
        totalExpense += element.amount;
      }
    });

    double available = totalIncome - totalExpense;
    double availablePercent = available / totalIncome;
    double expensePercent = totalExpense / totalIncome;

    var chartData = [
      new ChartSection('spend', expensePercent, Colors.red,
          (expensePercent * 100).toStringAsFixed(2) + ' % \nspend'),
      new ChartSection('available', availablePercent, Colors.green,
          (availablePercent * 100).toStringAsFixed(2) + ' %\navailable'),
    ];

    setState(() {
      _pieChartData.add(
        charts.Series(
          domainFn: (ChartSection chartSection, _) => chartSection.type,
          measureFn: (ChartSection chartSection, _) => chartSection.value,
          colorFn: (ChartSection chartSection, _) =>
              charts.ColorUtil.fromDartColor(chartSection.color),
          id: 'PieChartData',
          data: chartData,
          labelAccessorFn: (ChartSection row, _) => '${row.label}',
        ),
      );
    });
  }

  AppBar _buildAppBar(String _title) {
    return AppBar(
      elevation: 4.0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.lightGreen[200],
      title: Text(
        _title,
        style: TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<List<TransactionDTO>> _getTransactionsOfActualMonth() async {
    List<TransactionDTO> transactions = await DBController().transactions();
    int currentMonth = DateTime.now().month;

    return transactions
        .where((element) => _getMonthOf(element.dateTime) == currentMonth)
        .toList();
  }

  int _getMonthOf(int element) {
    return DateTime.fromMillisecondsSinceEpoch(element).month;
  }

  Widget buildPieChartContent() {
    return Expanded(
        child: Container(
      width: 500,
      child: charts.PieChart(_pieChartData,
          animate: true,
          animationDuration: Duration(seconds: 1),
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 80,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.auto)
              ])),
    ));
  }

  Widget buildSpendText() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: '',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: totalExpense.toStringAsFixed(2) + '€\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.red)),
                  TextSpan(text: 'of '),
                  TextSpan(
                    text: totalIncome.toStringAsFixed(2) + '€',
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(text: ' spend')
                ]),
          ),
        ));
  }

  int getRemainingDays() {
    DateTime today = DateTime.now();
    DateTime nextMonth = DateTime(today.year, (today.month % 12) + 1, 0);
    var dateUtil = DateUtil();
    return DateTime.fromMillisecondsSinceEpoch(
                nextMonth.millisecondsSinceEpoch - today.millisecondsSinceEpoch)
            .day %
        dateUtil.daysInMonth(today.month, today.year);
  }

  Widget buildCurrentBalance(){
    double balance = _currentbalance.currentbalance;

    return Padding(
      padding: EdgeInsets.all(16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Current Balance:\n',
          style: (balance < 0) ? GoogleFonts.openSans(fontSize: 30, color: Colors.red) : TextStyle(fontSize: 30, color: Colors.green),
          children: [
            TextSpan(
              text: balance.toStringAsFixed(2) + '€',
              style: TextStyle(fontWeight: FontWeight.bold)
            )
          ]
        ),
      )
    );
  }

  Widget buildPieChartContentOrPlaceholder(double available){
    if (available > 0){
      return buildPieChartContent();
    } 
    return Divider(
      height: 100,
      endIndent: 5,
      indent: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    double available = totalIncome - totalExpense;

    if (_pieChartData.isNotEmpty) {
        return Scaffold(
          appBar: _buildAppBar('Dashboard'),
          body: Card(
            elevation: 4.0, // shadow
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(children: <Widget>[
              buildCurrentBalance(),
              buildPieChartContentOrPlaceholder(available),
              buildSpendText(),
              Text(getRemainingDays().toString() + ' days remaining this month', style: GoogleFonts.openSans(),)
            ]),
          ),
        );
    }
    return Container();
  }
}

class ChartSection {
  String type;
  double value;
  Color color;
  String label;

  ChartSection(this.type, this.value, this.color, this.label);
}
