import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorDataDisplay(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 45, 158, 211),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
          ),
        ),
      ),
    );
  }
}

class SensorDataDisplay extends StatefulWidget {
  @override
  _SensorDataDisplayState createState() => _SensorDataDisplayState();
}

class _SensorDataDisplayState extends State<SensorDataDisplay> {
  String ultrasonicDistance = 'Loading...';
  bool lightStatus = false;
  bool fanStatus = false;
  bool autoMode = false;
  Timer? timer;
  String ipAddress = '192.168.9.17'; // Default IP address

  List<UltrasonicData> ultrasonicData = [];
  List<LdrData> ldrData = [];

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
    fetchSensorData();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchSensorData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = prefs.getString('ipAddress') ?? '192.168.9.17'; // Load saved IP or use default
    });
  }

  Future<void> _saveIpAddress(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', ip); // Save the IP address
  }

  Future<void> fetchSensorData() async {
  final apiUrl =
      'https://api.thingspeak.com/channels/2596814/feeds.json?api_key=FJIGDGIC3F0X15OC&results=1';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ultrasonicDistance = data['feeds'][0]['field1'] ?? 'N/A';
        ultrasonicDistance = ultrasonicDistance + ' %'; // Add % symbol
        String ldrValue = data['feeds'][0]['field3'] ?? '0.0';
        ultrasonicData.add(UltrasonicData(
          DateTime.now(),
          double.tryParse(ultrasonicDistance.replaceAll('%', '')) ?? 0.0, // Remove % for chart data
        ));

        ldrData.add(LdrData(
          DateTime.now(),
          double.tryParse(ldrValue) ?? 0.0,
        ));
      });
    } else {
      setState(() {
        ultrasonicDistance = 'Error fetching data';
      });
    }
  } catch (e) {
    setState(() {
      ultrasonicDistance = 'Error fetching data';
    });
  }
}

  Future<void> toggleRelay(String relay) async {
    final url = 'http://$ipAddress/$relay';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('$relay toggled successfully');
      } else {
        print('Failed to toggle $relay');
      }
    } catch (e) {
      print('Error toggling $relay: $e');
    }
  }

  Future<void> toggleMode() async {
    final url = 'http://$ipAddress/toggleMode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Mode toggled successfully');
        setState(() {
          autoMode = !autoMode;
        });
      } else {
        print('Failed to toggle mode');
      }
    } catch (e) {
      print('Error toggling mode: $e');
    }
  }

  void showIpEntryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('IP ADDRESS'),
          content: IpEntryScreen(
            currentIpAddress: ipAddress,
            onIpAddressSaved: (newIp) {
              setState(() {
                ipAddress = newIp;
              });
              _saveIpAddress(newIp); // Save the new IP address
              Navigator.pop(context); // Close the dialog
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMART HOME', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(221, 5, 5, 5),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle, color: const Color.fromARGB(255, 19, 204, 218)),
            onPressed: showIpEntryModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularSensorContainer(
                    title: 'WATER',
                    value: ultrasonicDistance,
                    icon: Icons.water_drop,
                  ),
                  _buildCircularSensorContainer(
                    title: 'LIGHT',
                    value: lightStatus ? 'ON' : 'OFF',
                    icon: Icons.lightbulb,
                    isToggleable: true,
                  ),
                  _buildCircularSensorContainer(
                    title: 'FAN',
                    value: fanStatus ? 'ON' : 'OFF',
                    icon: Icons.air,
                    isToggleable: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: toggleMode,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(),
                side: BorderSide(color: Colors.white, width: 0.8),
              ),
              child: Text(
                autoMode ? 'SWITCH TO MANUAL MODE' : 'SWITCH TO AUTO MODE',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            _buildChartSection(
              title: 'WATER LEVEL',
              dataSource: ultrasonicData,
              color: const Color.fromARGB(255, 175, 27, 16),
            ),
            _buildChartSection(
              title: 'LDR',
              dataSource: ldrData,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularSensorContainer({
    required String title,
    required String value,
    required IconData icon,
    bool isToggleable = false,
  }) {
    Color statusColor = value == 'ON' ? Colors.green : (value == 'OFF' ? Colors.red : Colors.white);

    return GestureDetector(
      onTap: isToggleable
          ? () {
              setState(() {
                if (title == 'LIGHT') {
                  lightStatus = !lightStatus;
                  toggleRelay('RELAY25toggle');
                } else if (title == 'FAN') {
                  fanStatus = !fanStatus;
                  toggleRelay('RELAY26toggle');
                }
              });
            }
          : null,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        height: 150,
        width: 120,
        decoration: BoxDecoration(
          color: Color(0xFF2E2E2E),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8.0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 40),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildChartSection({
    required String title,
    required List dataSource,
    required Color color,
  }) {
    return Container(
      height: 260,
      width: 370, // Decrease width here
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Add white border
          width: 0.6,
        ),
      ),
      child: SfCartesianChart(
        primaryXAxis: DateTimeCategoryAxis(),
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(fontSize: 12),
        ),
        series: <CartesianSeries>[
          LineSeries<dynamic, DateTime>(
            dataSource: dataSource,
            xValueMapper: (dynamic data, _) => data.time,
            yValueMapper: (dynamic data, _) => data.value,
            color: color,
          ),
        ],
      ),
    );
  }
}

class UltrasonicData {
  final DateTime time;
  final double value;

  UltrasonicData(this.time, this.value);
}

class LdrData {
  final DateTime time;
  final double value;

  LdrData(this.time, this.value);
}

class IpEntryScreen extends StatelessWidget {
  final String currentIpAddress;
  final Function(String) onIpAddressSaved;

  IpEntryScreen({required this.currentIpAddress, required this.onIpAddressSaved});

  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = TextEditingController(text: currentIpAddress);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: ipController,
          decoration: InputDecoration(
            labelText: 'Enter IP',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onIpAddressSaved(ipController.text);
          },
          child: Text('Connect'),
        ),
      ],
    );
  }
}
