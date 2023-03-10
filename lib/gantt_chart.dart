import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gantt_chart/date_converter.dart';
import 'package:flutter_gantt_chart/get_response.dart';
import 'dart:math';

import 'models.dart';

enum GanttChartLoader { initial, loading, success, error }


class GanttChartScreen extends StatefulWidget {
  const GanttChartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return GanttChartScreenState();
  }
}

class GanttChartScreenState extends State<GanttChartScreen> {
  late List<TasksDataModel> tasksList = [];

  GanttChartLoader loadingState = GanttChartLoader.initial;

  late String errorMessage = "";

  @override
  void initState() {
    super.initState();
    getDataFromAPI();
  }

  getDataFromAPI() async {
    loadingState = GanttChartLoader.loading;

    TasksModel response = await BaseService.getTasksData();

    if (response.success == true) {
      loadingState = GanttChartLoader.success;
      setState(() {
        tasksList = response.data;
        debugPrint("task success list => $tasksList");
      });
    } else {
      loadingState = GanttChartLoader.success;
      debugPrint("some error occurred => ${response.message}");
      setState(() {
        errorMessage = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Gantt Chart'),
          ),
          body: loadingState == GanttChartLoader.success
              ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasksList.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final indexItem = tasksList[index];

                final colorInt =
                int.parse(indexItem.color.replaceAll("#", "0xFF"));

                debugPrint("task lst length => ${tasksList.length}");
                return GanttChart(
                  fromDate: DateTime.parse(indexItem.startDate),
                  toDate: DateTime.parse(indexItem.endDate),
                  tasksList: tasksList[index],
                  taskColor: Color(colorInt),
                  taskName: indexItem.text,
                  completePercent: indexItem.progress,
                );
              },
            ),
          )
              : Center(
            child: Text(errorMessage),
          ),
        ),
        if (loadingState == GanttChartLoader.loading)
          Container(
            // color: Colors.black.withAlpha(60),
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(color: Colors.black),
          )
      ],
    );
  }
}

class GanttChart extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final TasksDataModel tasksList;
  final String taskName;
  final Color taskColor;
  final int completePercent;

  int viewRange;
  int viewRangeToFitScreen = 6;

  GanttChart({
    required this.fromDate,
    required this.toDate,
    this.viewRange = 0,
    this.viewRangeToFitScreen = 0,
    required this.tasksList,
    required this.taskName,
    required this.taskColor,
    required this.completePercent,
  }) {
    viewRange = calculateNumberOfMonthsBetween(fromDate, toDate);
    debugPrint("view range => $viewRange");
  }

  int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    // return to.month - from.month + 12 * (to.year - from.year) + 1;
    return to.difference(from).inDays;
  }

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(fromDate) <= 0) {
      return 0;
    } else {
      return calculateNumberOfMonthsBetween(fromDate, projectStartedAt) - 1;
    }
  }

  int calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    int projectLength =
    calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);
    if (projectStartedAt.compareTo(fromDate) >= 0 &&
        projectStartedAt.compareTo(toDate) <= 0) {
      if (projectLength <= viewRange) {
        return projectLength;
      } else {
        return viewRange -
            calculateNumberOfMonthsBetween(fromDate, projectStartedAt);
      }
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(fromDate)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(toDate)) {
      return projectLength -
          calculateNumberOfMonthsBetween(projectStartedAt, fromDate);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isAfter(toDate)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      TasksDataModel dataItem, double chartViewWidth, BuildContext context) {
    List<Widget> chartBars = [];

    for (int index = 0; index < dataItem.childs.length; index++) {
      final childIndex = dataItem.childs[index];

      debugPrint(" 1st child index loop => $index");

      debugPrint(
          " 1st child list length => ${dataItem.childs.length}, parent id => ${dataItem.childs[index].parent}");

      debugPrint("=================================================");

      // if(childIndex.parent == dataItem.id) {
      var remainingWidth = calculateRemainingWidth(
          DateTime.parse(childIndex.startDate),
          DateTime.parse(childIndex.endDate));

      if (remainingWidth > 0) {
        final intColor = childIndex.color.replaceAll("#", "0xff");

        final Color cColor = Color(int.parse(intColor));

        debugPrint("parent id => ${dataItem.id}");

        debugPrint("child id => ${childIndex.parent}");

        if (dataItem.id == childIndex.parent) {
          chartBars.add(
            Stack(
              children: [
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: cColor.withAlpha(100),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withAlpha(70),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  margin: EdgeInsets.only(
                      left: calculateDistanceToLeftBorder(
                          DateTime.parse(childIndex.startDate)) *
                          chartViewWidth /
                          viewRangeToFitScreen,
                      top: dataItem == 0 ? 4.0 : 2.0,
                      bottom:
                      dataItem == childIndex.childs.length - 1 ? 4.0 : 2.0),
                  width:
                  (remainingWidth * chartViewWidth / viewRangeToFitScreen) *
                      double.parse(childIndex.progress.toString()) /
                      100,
                  decoration: BoxDecoration(
                    color: cColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: cColor.withOpacity(0.4),
                          spreadRadius: -5,
                          blurRadius: 9,
                          offset: const Offset(0, 2))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: cColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 25.0,
                  width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
                  margin: EdgeInsets.only(
                      left: calculateDistanceToLeftBorder(
                          DateTime.parse(childIndex.startDate)) *
                          chartViewWidth /
                          viewRangeToFitScreen,
                      top: dataItem == 0 ? 4.0 : 2.0,
                      bottom:
                      dataItem == dataItem.childs.length - 1 ? 4.0 : 2.0),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      childIndex.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        debugPrint("char bar length => ${chartBars.length}");

        if (childIndex.childs.isNotEmpty) {
          for (int cIndex = 0; cIndex < childIndex.childs.length; cIndex++) {
            debugPrint(
                "child inside child length => ${childIndex.childs.length}");

            final childItem = childIndex.childs[cIndex];

            var remainingChildWidth = calculateRemainingWidth(
                DateTime.parse(childItem.startDate),
                DateTime.parse(childItem.endDate));

            final intColor = childItem.color.replaceAll("#", "0xff");

            final Color cColor = Color(int.parse(intColor));

            chartBars.add(
              Stack(
                children: [
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: cColor.withAlpha(100),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withAlpha(70),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    margin: EdgeInsets.only(
                        left: calculateDistanceToLeftBorder(
                            DateTime.parse(childItem.startDate)) *
                            chartViewWidth /
                            viewRangeToFitScreen,
                        top: dataItem == 0 ? 4.0 : 2.0,
                        bottom: dataItem == childIndex.childs.length - 1
                            ? 4.0
                            : 2.0),
                    width: (remainingChildWidth *
                        chartViewWidth /
                        viewRangeToFitScreen) *
                        double.parse(completePercent.toString()) /
                        100,
                    decoration: BoxDecoration(
                      color: cColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: cColor.withOpacity(0.4),
                            spreadRadius: -5,
                            blurRadius: 9,
                            offset: const Offset(0, 2))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: cColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 25.0,
                    width: remainingChildWidth *
                        chartViewWidth /
                        viewRangeToFitScreen,
                    margin: EdgeInsets.only(
                        left: calculateDistanceToLeftBorder(
                            DateTime.parse(childItem.startDate)) *
                            chartViewWidth /
                            viewRangeToFitScreen,
                        top: dataItem == 0 ? 4.0 : 2.0,
                        bottom: dataItem == childIndex.childs.length - 1
                            ? 4.0
                            : 2.0),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        childItem.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
      // }
    }
    return chartBars;
  }

  Widget buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = [];

    DateTime tempDate = fromDate;

    // headerItems.add(SizedBox(
    //   width: chartViewWidth / viewRangeToFitScreen,
    //   child: const Text(
    //     'NAME',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontSize: 10.0,
    //     ),
    //   ),
    // ));

    final List<DateTime> singleDays = [];

    DateTime lastDay = DateTime(tempDate.year, tempDate.month, tempDate.day);
    for (int i = 0; i < viewRange; i++) {
      singleDays.add(lastDay.add(Duration(days: i)));

      final indexItem = singleDays[i];
      headerItems.add(
        SizedBox(
          width: chartViewWidth / viewRangeToFitScreen,
          child: Text(
            EasyDateConverter.nepaliDateFormatToHalfMonthDay(
              date: EasyDateConverter.englishDateToNepaliDate(
                  date:
                  "${singleDays[i].year}/${indexItem.month >= 0 && indexItem.month <= 9 ? "0${indexItem.month}" : singleDays[i].month}/${indexItem.day >= 0 && indexItem.day <= 9 ? "0${indexItem.day}" : singleDays[i].day}"),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      );
      tempDate = lastDay;
    }

    return Container(
      height: 25.0,
      color: color.withAlpha(100),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= viewRange - 1; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        width: chartViewWidth / viewRangeToFitScreen,
        //height: 300.0,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget buildChartForEachUser(
      TasksDataModel userData, double chartViewWidth, BuildContext context) {
    // Color color = randomColorGenerator();

    var chartBars = buildChartBars(userData, chartViewWidth, context);

    return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withAlpha(90))),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: taskColor.withAlpha(100),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withAlpha(70),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width *
                          double.parse(completePercent.toString()) /
                          100,
                      decoration: BoxDecoration(
                          color: taskColor.withOpacity(0.9),
                          // borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(12.0),
                          //     bottomRight: Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                                color: taskColor.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 9,
                                offset: const Offset(0, 2))
                          ]),
                    ),
                    Center(
                      child: RotatedBox(
                        quarterTurns:
                        chartBars.length * 29.0 + 4.0 > 50 ? 0 : 0,
                        child: Column(
                          children: [
                            Text(
                              taskName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.5, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              "${EasyDateConverter.nepaliDateFormatToHalfMonthDay(date: EasyDateConverter.englishDateToNepaliDate(date: fromDate.toString()))} to ${EasyDateConverter.nepaliDateFormatToHalfMonthDay(date: EasyDateConverter.englishDateToNepaliDate(date: toDate.toString()))} (${toDate.difference(fromDate).inDays} days)",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if(tasksList.status == "1")
                  Container(
                    width: 80,
                    margin: EdgeInsets.only(right: 4.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 3.0),
                        Text(
                          "Completed",
                          style: TextStyle(fontSize: 9.5,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: chartBars.length * 29.0 + 25.0 + chartBars.length * 12,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    buildGrid(chartViewWidth),
                    buildHeader(chartViewWidth, Colors.white),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chartBars,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  List<Widget> buildChartContent(double chartViewWidth, BuildContext context) {
    List<Widget> chartContent = [];

    // for (var user in tasksList) {
    //   List<TasksDataModel> projectsOfUser = [];
    //
    //   // projectsOfUser = tasksList
    //   //     .where(
    //   //         (project) => project.id.toString().contains(user.id.toString()))
    //   //     .toList();
    //
    //   if (projectsOfUser.isNotEmpty) {}
    // }

    chartContent.add(buildChartForEachUser(tasksList, chartViewWidth, context));
    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var chartViewWidth = MediaQuery.of(context).size.width;
    var screenOrientation = MediaQuery.of(context).orientation;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Column(
        children: buildChartContent(chartViewWidth, context),
      ),
    );
  }
}
