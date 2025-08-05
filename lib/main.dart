import 'package:flutter/material.dart';

void main() {
  runApp(HasanatiApp());
}

class HasanatiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حسناتي',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'حسناتي - التطبيق الإسلامي'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tasbihCount = 0;

  void _incrementTasbih() {
    setState(() {
      _tasbihCount++;
    });
  }

  void _resetTasbih() {
    setState(() {
      _tasbihCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Header
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'بسم الله الرحمن الرحيم',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Tasbih Counter
            Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'عداد التسبيح',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$_tasbihCount',
                      style: TextStyle(fontSize: 48, color: Colors.green[800]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _incrementTasbih,
                          child: Text('تسبيح'),
                        ),
                        ElevatedButton(
                          onPressed: _resetTasbih,
                          child: Text('إعادة تعيين'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Azkar List
            Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'الأذكار',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildZikrItem('سبحان الله'),
                    _buildZikrItem('الحمد لله'),
                    _buildZikrItem('لا إله إلا الله'),
                    _buildZikrItem('الله أكبر'),
                    _buildZikrItem('أستغفر الله'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Prayer Times
            Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'مواقيت الصلاة',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildPrayerTime('الفجر', '05:30'),
                    _buildPrayerTime('الظهر', '12:15'),
                    _buildPrayerTime('العصر', '15:30'),
                    _buildPrayerTime('المغرب', '18:00'),
                    _buildPrayerTime('العشاء', '19:30'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZikrItem(String zikr) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: _incrementTasbih,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]),
          ),
          child: Text(
            zikr,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTime(String prayer, String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayer,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 16, color: Colors.green[800]),
          ),
        ],
      ),
    );
  }
}