import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagramPage extends StatefulWidget {
  final Widget child;

  DiagramPage({Key key, this.child}) : super(key: key);

  _DiagramPageState createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  List<charts.Series<SolidBarData, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
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

    var piedata = [
      new Task('spend', 35.8, Color(0xffff0000)),
      new Task('available', 50, Color(0xff00ff00)),
      new Task('blocked', 24.2, Color(0xffffa500)),
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

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'SolidBarData',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
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

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<SolidBarData, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
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
      labelColor: Color(0xff1976d2),
      indicatorColor: Color(0xff9962D0),
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

  Padding buildChartContainer(var content){
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
                  defaultRenderer: new charts.LineRendererConfig(
                      includeArea: true, stacked: true),
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
    return <Widget>[
            Text(
              'DonutChart Expenditures',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: charts.PieChart(_seriesPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 2,
                      cellPadding:
                          new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
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

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
