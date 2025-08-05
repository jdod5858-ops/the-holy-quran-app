import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../models/dhikr.dart';
import '../../../services/adhkar_service.dart';
import '../../../providers/app_provider.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Dhikr> morningAdhkar = [];
  List<Dhikr> eveningAdhkar = [];
  List<Dhikr> sleepAdhkar = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    loadAdhkar();
  }

  Future<void> loadAdhkar() async {
    try {
      final morning = await AdhkarService.getMorningAdhkar();
      final evening = await AdhkarService.getEveningAdhkar();
      final sleep = await AdhkarService.getSleepAdhkar();
      
      setState(() {
        morningAdhkar = morning;
        eveningAdhkar = evening;
        sleepAdhkar = sleep;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.duas),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: localizations.morningAdhkar),
            Tab(text: localizations.eveningAdhkar),
            Tab(text: localizations.sleepAdhkar),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: tabController,
              children: [
                AdhkarList(adhkar: morningAdhkar),
                AdhkarList(adhkar: eveningAdhkar),
                AdhkarList(adhkar: sleepAdhkar),
              ],
            ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class AdhkarList extends StatelessWidget {
  final List<Dhikr> adhkar;

  const AdhkarList({super.key, required this.adhkar});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: adhkar.length,
      itemBuilder: (context, index) {
        final dhikr = adhkar[index];
        return DhikrCard(dhikr: dhikr);
      },
    );
  }
}

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;

  const DhikrCard({super.key, required this.dhikr});

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  int currentCount = 0;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.dhikr.arabic,
                style: TextStyle(
                  fontSize: appProvider.fontSize + 4,
                  fontFamily: 'Noor',
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Transliteration
            Text(
              widget.dhikr.transliteration,
              style: TextStyle(
                fontSize: appProvider.fontSize,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Translation
            Text(
              appProvider.isArabic 
                  ? widget.dhikr.translationAr 
                  : widget.dhikr.translationEn,
              style: TextStyle(
                fontSize: appProvider.fontSize,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Count and reference
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dhikr.reference,
                  style: TextStyle(
                    fontSize: appProvider.fontSize - 2,
                    color: Colors.grey[600],
                  ),
                ),
                if (widget.dhikr.count > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.dhikr.count}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            // Counter for multiple recitations
            if (widget.dhikr.count > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${appProvider.isArabic ? 'العدد' : 'Count'}: $currentCount / ${widget.dhikr.count}',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: currentCount > 0 
                            ? () => setState(() => currentCount--) 
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      IconButton(
                        onPressed: currentCount < widget.dhikr.count 
                            ? () => setState(() => currentCount++) 
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () => setState(() => currentCount = 0),
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Progress bar
              LinearProgressIndicator(
                value: currentCount / widget.dhikr.count,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}