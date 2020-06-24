import 'package:flutter/foundation.dart';

import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class DiagramPage extends StatefulWidget {
  final Widget child;

  DiagramPage({Key key, this.child}) : super(key: key);

  _DiagramPageState createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  List<charts.Series<SolidBarData, String>> _seriesBarData = List<charts.Series<SolidBarData, String>>();
  List<charts.Series<PieChartSection, String>> _seriesPieData = List<charts.Series<PieChartSection, String>>();
  List<charts.Series<LineChartExpenditures, int>> _seriesLineData = List<charts.Series<LineChartExpenditures, int>>();

  Future<void> _fetchPieData() async {
    DateTime thisMonth = getPreviousMonth(0);
    List<TransactionDTO> transactions = await DBController()
        .transactionsByMoth(thisMonth.millisecondsSinceEpoch);

    double totalExpense = 0;

    List<SortCategoryHelper> sortedCategories = List<SortCategoryHelper>();
    transactions.forEach((transaction) {
      if (transaction.type == 'expense') {
        totalExpense += transaction.amount;
      }

      int index = sortedCategories
          .indexWhere((element) => element.categoryId == transaction.category);

      if (index != -1) {
        sortedCategories[index].transactions.add(transaction);
      } else {
        sortedCategories
            .add(SortCategoryHelper(transaction.category, [transaction]));
      }
    });

    List<PieChartSection> chartData = List<PieChartSection>();
    sortedCategories.forEach((element) async {
      double sum = 0;
      element.transactions.forEach((transaction) {
        if (transaction.type == 'expense') {
          sum += transaction.amount;
        }
      });

      if (sum > 0) {
        double percentage = sum / totalExpense;
        CategoryDTO category =
            await DBController().getCategoryById(element.categoryId);
        String label = category.category +
            '\n' +
            sum.toStringAsFixed(2) +
            '€, ' +
            (percentage * 100).toStringAsFixed(2) +
            '%';
        chartData.add(
            PieChartSection(percentage, RandomColor().randomColor(), label));
      }
    });

    setState(() {
      _seriesPieData.add(
        charts.Series(
          domainFn: (PieChartSection section, _) => section.label,
          measureFn: (PieChartSection section, _) => section.value,
          colorFn: (PieChartSection section, _) =>
              charts.ColorUtil.fromDartColor(section.color),
          id: 'PieChartData',
          data: chartData,
          labelAccessorFn: (PieChartSection section, _) => '${section.label}',
        ),
      );
    });
  }

  List<double> getTotal(List<TransactionDTO> transactions, int index) {
    double totalSpend = 0;
    double totalEarned = 0;

    transactions.forEach((transaction) {
      if (transaction.type == 'income') {
        totalEarned += transaction.amount;
      } else {
        totalSpend += transaction.amount;
      }
    });

    return [totalEarned, totalSpend];
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
    }
    return '';
  }

  String getIdString(int key) {
    switch (key) {
      case 0:
        return 'spend';
      case 1:
        return 'earned';
      case 2:
        return 'saved';
      default:
        return '';
    }
  }

  Color getColorForId(int key) {
    switch (key) {
      case 0:
        return Color(0xff990099);
      case 1:
        return Color(0xff109618);
      case 2:
        return Color(0xffff9900);
      default:
        return Color(0);
    }
  }

  Future<void> _fetchBarData() async {
    List<List<TransactionDTO>> multipleMonthsTransactions =
        List<List<TransactionDTO>>();

    for (int i = 0; i < 3; i++) {
      multipleMonthsTransactions.add(await DBController()
          .transactionsByMoth(getPreviousMonth(i).millisecondsSinceEpoch));
    }

    var barData = [
      List<SolidBarData>(),
      List<SolidBarData>(),
      List<SolidBarData>()
    ]; // spend, earned, saved

    multipleMonthsTransactions.asMap().forEach((index, transactions) {
      List<double> totals = getTotal(transactions, index);
      int currentMonth = getPreviousMonth(index).month;

      double savedPercent = totals[0] - totals[1];
      String currentMonthString = getMonthString(currentMonth);

      barData[0].add(SolidBarData(currentMonthString, currentMonth, totals[1]));
      barData[1].add(SolidBarData(currentMonthString, currentMonth, totals[0]));
      barData[2]
          .add(SolidBarData(currentMonthString, currentMonth, savedPercent));
    });

    barData.asMap().forEach((key, value) {
        _seriesBarData.add(
          charts.Series(
            domainFn: (SolidBarData usage, _) => usage.month,
            measureFn: (SolidBarData usage, _) => usage.quantity,
            id: getIdString(key),
            data: value,
            fillPatternFn: (_, __) => key == 2? charts.FillPatternType.forwardHatch : charts.FillPatternType.solid,
            colorFn: (SolidBarData usage, _) =>
                charts.ColorUtil.fromDartColor(getColorForId(key)),
          ),
        );
        debugPrint('Added Data: $key');
      });

    setState(() {
      _seriesBarData = _seriesBarData;
      debugPrint('###############################state Set########################################');
    });
  }

  DateTime getPreviousMonth(int monthsBefore) {
    DateTime today = DateTime.now();
    int newMonths = today.month - monthsBefore;
    if (newMonths <= 0) {
      newMonths += 12;
    }
    return DateTime(today.year, newMonths, 1);
  }

  Future<void> _fetchLineData() async{
    var lineData = [List<LineChartExpenditures>(), List<LineChartExpenditures>(), List<LineChartExpenditures>()];
    

    for (int i = 0; i < 3; i++){
      List<TransactionDTO> currentTransactions = await DBController().transactionsByMoth(getPreviousMonth(i).millisecondsSinceEpoch);
      var days = List<double>.filled(32, 0); 
      currentTransactions.forEach((element) {
        if (element.type == 'expense'){
          days[DateTime.fromMillisecondsSinceEpoch(element.dateTime).day] += element.amount;
        }
      });

      double totalExpense = 0;
      days.asMap().forEach((key, value) {
        if (value != 0){
          totalExpense += value;
          lineData[i].add(LineChartExpenditures(key, totalExpense));
        }
      });
      if (days[31] == 0){
        lineData[i].add(LineChartExpenditures(31, totalExpense));
      }
    }

    lineData.asMap().forEach((key, element) {
      setState(() {
        _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(getColorForId(key)),
        id: getMonthString(getPreviousMonth(key).month),
        data: element,
        domainFn: (LineChartExpenditures expenditures, _) => expenditures.day,
        measureFn: (LineChartExpenditures expenditures, _) => expenditures.expenseValue,
      ),
    );
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchBarData();
    _fetchPieData();
    _fetchLineData();
  }

  @override
  Widget build(BuildContext context) {
    if (_seriesBarData.isNotEmpty){
      return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
          appBar: createAppBar(),
          body: buildTabBarView(),
          ),
        ),
      );
    } else {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
          appBar: createAppBar(),
          body: Container(),
          ),
        ),
      );
    }
    
  }

  TabBar createAppBar() {
    return TabBar(
      labelColor: Colors.green,
      indicatorColor: Colors.grey[500],
      tabs: [
        Tab(
          icon: Icon(FontAwesomeIcons.solidChartBar),
        ),
        Tab(icon: Icon(FontAwesomeIcons.chartPie)),
        Tab(icon: Icon(FontAwesomeIcons.chartLine)),
      ],
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      children: [
        buildBarChart(),
        buildPieChart(),
        buildLineChart(),
      ],
    );
  }

  Padding buildLineChart() {
    return buildChartContainer(buildLineChartContent());
  }

  Padding buildPieChart() {
    return buildChartContainer(buildPieChartContent());
  }

  Padding buildBarChart() {
    return buildChartContainer(buildBarChartContent());
  }

  Padding buildChartContainer(var content) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: content,
          ),
        ),
      ),
    );
  }

  List<Widget> buildLineChartContent() {
    return <Widget>[
      Text(
        'Expenditures of the last three months',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: charts.LineChart(_seriesLineData,
            defaultRenderer:
                new charts.LineRendererConfig(includeArea: true, stacked: false),
            animate: true,
            animationDuration: Duration(seconds: 1),
            behaviors: [
              new charts.ChartTitle('Days',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle('Expenditures',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend()
            ]),
      ),
    ];
  }

  List<Widget> buildPieChartContent() {
    if (_seriesPieData.isEmpty) {
      return [Container()];
    }
    return <Widget>[
      buildTitleCard('Expenditures this Month by Category'),
      SizedBox(
        height: 10.0,
      ),
      Expanded(
        child: charts.PieChart(_seriesPieData,
            animate: true,
            animationDuration: Duration(seconds: 1),
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 100,
                arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.auto)
                ])),
      ),
    ];
  }

  List<Widget> buildBarChartContent() {
    return <Widget>[
      buildTitleCard('Expenditures, Earnings and Savings per month'),
      Expanded(
        child: charts.BarChart(
          _seriesBarData,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [new charts.SeriesLegend()],
          animationDuration: Duration(seconds: 1),
        ),
      ),
    ];
  }

  Widget buildTitleCard(String text) {
    return Card(
        elevation: 4.0, // shadow
        margin: const EdgeInsets.all(8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  fontSize: 24.0, fontWeight: FontWeight.bold),
            )));
  }
}

class SolidBarData {
  String month;
  int monthNr;
  double quantity;

  SolidBarData(this.month, this.monthNr, this.quantity);
}

class PieChartSection {
  double value;
  Color color;
  String label;

  PieChartSection(this.value, this.color, this.label);
}

class SortCategoryHelper {
  int categoryId;
  List<TransactionDTO> transactions = List<TransactionDTO>();

  SortCategoryHelper(this.categoryId, this.transactions);
}

class LineChartExpenditures {
  int day;
  double expenseValue;

  LineChartExpenditures(this.day, this.expenseValue);
}
