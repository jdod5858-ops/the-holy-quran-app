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
        fontFamily: 'Arial',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    QuranPage(),
    AzkarPage(),
    QiblaPage(),
    PrayerTimesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حسناتي - التطبيق الإسلامي'),
        backgroundColor: Colors.green,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'القرآن الكريم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'القبلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'مواقيت الصلاة',
          ),
        ],
      ),
    );
  }
}

class QuranPage extends StatelessWidget {
  final List<Map<String, dynamic>> surahs = [
    {'name': 'الفاتحة', 'verses': 7, 'number': 1},
    {'name': 'البقرة', 'verses': 286, 'number': 2},
    {'name': 'آل عمران', 'verses': 200, 'number': 3},
    {'name': 'النساء', 'verses': 176, 'number': 4},
    {'name': 'المائدة', 'verses': 120, 'number': 5},
    {'name': 'الأنعام', 'verses': 165, 'number': 6},
    {'name': 'الأعراف', 'verses': 206, 'number': 7},
    {'name': 'الأنفال', 'verses': 75, 'number': 8},
    {'name': 'التوبة', 'verses': 129, 'number': 9},
    {'name': 'يونس', 'verses': 109, 'number': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
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
        Expanded(
          child: ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      '${surah['number']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    surah['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${surah['verses']} آية'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to surah details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AzkarPage extends StatefulWidget {
  @override
  _AzkarPageState createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  int _tasbihCount = 0;
  
  final List<String> azkar = [
    'سبحان الله',
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر',
    'لا حول ولا قوة إلا بالله',
    'أستغفر الله',
    'سبحان الله وبحمده',
    'سبحان الله العظيم',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'الأذكار والتسبيح',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green),
            ),
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
                      onPressed: () {
                        setState(() {
                          _tasbihCount++;
                        });
                      },
                      child: Text('تسبيح'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _tasbihCount = 0;
                        });
                      },
                      child: Text('إعادة تعيين'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: azkar.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      azkar[index],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      setState(() {
                        _tasbihCount++;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore,
            size: 100,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Text(
            'اتجاه القبلة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'استخدم البوصلة لتحديد اتجاه القبلة',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement compass functionality
            },
            child: Text('تحديد القبلة'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}

class PrayerTimesPage extends StatelessWidget {
  final List<Map<String, String>> prayerTimes = [
    {'name': 'الفجر', 'time': '05:30'},
    {'name': 'الشروق', 'time': '06:45'},
    {'name': 'الظهر', 'time': '12:15'},
    {'name': 'العصر', 'time': '15:30'},
    {'name': 'المغرب', 'time': '18:00'},
    {'name': 'العشاء', 'time': '19:30'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'مواقيت الصلاة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: prayerTimes.length,
              itemBuilder: (context, index) {
                final prayer = prayerTimes[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.access_time, color: Colors.green),
                    title: Text(
                      prayer['name']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      prayer['time']!,
                      style: TextStyle(fontSize: 18, color: Colors.green[800]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}