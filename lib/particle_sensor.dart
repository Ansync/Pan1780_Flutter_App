import 'package:flutter/material.dart';
import 'state.dart';
import 'particle_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

var state = MyState();

class ParticleSensor extends StatefulWidget {
  @override
  _ParticleSensorState createState() => _ParticleSensorState();
}

class _ParticleSensorState extends State<ParticleSensor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Particle Sensor",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: state.deviceHeight * 0.035)),
        centerTitle: true,
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Panasonic\nSN-GCJA5 Particle Matter Sensor",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: state.deviceHeight * 0.03)),
          Container(
            height: state.deviceHeight * 0.05,
          ),
          ChangeNotifierProvider.value(
            value: state.particleSensor,
            child: Column(
              children: [
                Text(
                  "Particulate Matter",
                  style: TextStyle(fontSize: state.deviceHeight * 0.025),
                ),
                Container(
                  width: state.deviceWidth * 0.9,
                  height: state.deviceHeight * 0.5,
                  child: Consumer<ParticleDataSensor>(
                      builder: (context, widget, child) {
                    return LiveParticleChart();
                  }),
                ),
                Divider(),
                Text(
                  "Particle Counts",
                  style: TextStyle(fontSize: state.deviceHeight * 0.025),
                ),
                Container(
                  width: state.deviceWidth * 0.9,
                  height: state.deviceHeight * 0.5,
                  child: Consumer<ParticleDataSensor>(
                      builder: (context, widget, child) {
                    return LiveParticleCountChart();
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LiveParticleChart extends StatefulWidget {
  @override
  _LiveParticleChartState createState() => _LiveParticleChartState();
}

class _LiveParticleChartState extends State<LiveParticleChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        trackballBehavior:
            TrackballBehavior(enable: true, lineColor: Colors.black),
        zoomPanBehavior:
            ZoomPanBehavior(enablePanning: true, enablePinching: true),
        primaryXAxis: CategoryAxis(
            labelRotation: 45,
            title: AxisTitle(
                text: 'Data Point Count',
                textStyle: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w300))),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
                alignment: ChartAlignment.center,
                text: 'µgm3 (Mass)',
                textStyle: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w300))),
        legend: Legend(position: LegendPosition.top, isVisible: true),
        series: <ChartSeries>[
          // Renders line chart
          LineSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.red,
              legendItemText: "PM1.0",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.sensorDataPointsOne,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),

          // Renders line chart
          LineSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.green,
              legendItemText: "PM2.5",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.sensorDataPointsTwo,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),

          // Renders line chart
          LineSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.blue,
              legendItemText: "PM10",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.sensorDataPointsThree,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),
        ]);
  }
}

class LiveParticleCountChart extends StatefulWidget {
  @override
  _LiveParticleCountChartState createState() => _LiveParticleCountChartState();
}

class _LiveParticleCountChartState extends State<LiveParticleCountChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        trackballBehavior:
            TrackballBehavior(enable: true, lineColor: Colors.black),
        zoomPanBehavior:
            ZoomPanBehavior(enablePanning: true, enablePinching: true),
        primaryXAxis: CategoryAxis(
            labelRotation: 45,
            title: AxisTitle(
                text: 'Data Point Count',
                textStyle: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w300))),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
                alignment: ChartAlignment.center,
                text: 'Particle Count',
                textStyle: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w300))),
        legend: Legend(
            position: LegendPosition.top,
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap),
        series: <ChartSeries>[
          // Renders line chart
          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.red,
              legendItemText: "(0.3-0.5μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.o0Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),
          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.green,
              legendItemText: "(0.5-1.0μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.o1Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),

          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.blue,
              legendItemText: "(1.0-2.5μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.p0Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),
          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.purple,
              legendItemText: "(2.5-5.0μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.p1Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),

          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.orange,
              legendItemText: "(5.0-7.5μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.q0Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),
          ScatterSeries<ParticleData, dynamic>(
              animationDuration: 100.0,
              color: Colors.yellow,
              legendItemText: "(7.5-10.0μm)",
              markerSettings: MarkerSettings(isVisible: true),
              dataSource: state.particleSensor.q1Data,
              xValueMapper: (ParticleData dataPoint, _) => dataPoint.timeStamp,
              yValueMapper: (ParticleData dataPoint, _) => dataPoint.data),
        ]);
  }
}
