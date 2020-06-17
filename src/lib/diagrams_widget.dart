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
  List<charts.Series<SolidBarData, String>> _seriesData;
  List<charts.Series<PieChartSection, String>> _seriesPieData;
  List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() {
    var data1 = [
      new SolidBarData(09, 'spend', 30),
      new SolidBarData(10, 'earned', 45),
      new SolidBarData(11, 'saved', 25),
    ];
    var data2 = [
      new SolidBarData(09, 'spend', 40),
      new SolidBarData(10, 'earned', 55),
      new SolidBarData(11, 'saved', 10),
    ];
    var data3 = [
      new SolidBarData(09, 'spend', 40),
      new SolidBarData(10, 'earned', 50),
      new SolidBarData(11, 'saved', 15),
    ];

    var linesalesdata = [
      new Sales(0, 45),
      new Sales(1, 56),
      new Sales(2, 55),
      new Sales(3, 60),
      new Sales(4, 61),
      new Sales(5, 70),
    ];
    var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 60),
    ];

    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(1, 24),
      new Sales(2, 25),
      new Sales(3, 40),
      new Sales(4, 45),
      new Sales(5, 60),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (SolidBarData usage, _) => usage.usage,
        measureFn: (SolidBarData usage, _) => usage.quantity,
        id: 'Sep',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (SolidBarData usage, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (SolidBarData usage, _) => usage.usage,
        measureFn: (SolidBarData usage, _) => usage.quantity,
        id: 'oct',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (SolidBarData usage, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (SolidBarData usage, _) => usage.usage,
        measureFn: (SolidBarData usage, _) => usage.quantity,
        id: 'nov',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (SolidBarData usage, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'SolidBarData',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'SolidBarData',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'SolidBarData',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  Future<void> _fetchPieData() async {
    DateTime today = DateTime.now();
    DateTime thisMonth = DateTime(today.year, today.month, 1);
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

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<SolidBarData, String>>();
    _seriesPieData = List<charts.Series<PieChartSection, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
    _fetchPieData();
  }

  @override
  Widget build(BuildContext context) {
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
        'Sales for the first 5 years TESTDATA',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: charts.LineChart(_seriesLineData,
            defaultRenderer:
                new charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            animationDuration: Duration(seconds: 1),
            behaviors: [
              new charts.ChartTitle('Years',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle('Sales',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
                'Departments',
                behaviorPosition: charts.BehaviorPosition.end,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea,
              )
            ]),
      ),
    ];
  }

  List<Widget> buildPieChartContent() {
    if (_seriesPieData.isEmpty) {
      return [Container()];
    }
    return <Widget>[
      Card(
          elevation: 4.0, // shadow
          margin: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Expenditures by Category this Month',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(fontSize: 24.0, fontWeight: FontWeight.bold),
              ))),
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
      Text(
        'Expenditures and earnings per month',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: charts.BarChart(
          _seriesData,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          //behaviors: [new charts.SeriesLegend()],
          animationDuration: Duration(seconds: 1),
        ),
      ),
    ];
  }
}

class SolidBarData {
  String usage;
  int month;
  int quantity;

  SolidBarData(this.month, this.usage, this.quantity);
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

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
