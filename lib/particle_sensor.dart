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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            child: Container(
              width: state.deviceWidth * 0.9,
              height: state.deviceHeight * 0.5,
              child: Consumer<ParticleDataSensor>(
                  builder: (context, widget, child) {
                return LiveParticleChart();
              }),
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
        primaryXAxis: CategoryAxis(
            labelRotation: 45,
            title: AxisTitle(
                text: 'Data Point Count',
                textStyle: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w300))),
        primaryYAxis: CategoryAxis(
            title: AxisTitle(
                text: 'µgm3',
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
