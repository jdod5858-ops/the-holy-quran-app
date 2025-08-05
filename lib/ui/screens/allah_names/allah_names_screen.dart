import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../models/allah_name.dart';
import '../../../services/allah_names_service.dart';
import '../../../providers/app_provider.dart';

class AllahNamesScreen extends StatefulWidget {
  const AllahNamesScreen({super.key});

  @override
  State<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends State<AllahNamesScreen> {
  List<AllahName> allahNames = [];
  List<AllahName> filteredNames = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllahNames();
  }

  Future<void> loadAllahNames() async {
    try {
      final names = await AllahNamesService.getAllahNames();
      setState(() {
        allahNames = names;
        filteredNames = names;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterNames(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNames = allahNames;
      } else {
        filteredNames = allahNames.where((name) =>
          name.name.contains(query) ||
          name.transliteration.toLowerCase().contains(query.toLowerCase()) ||
          name.meaningAr.contains(query) ||
          name.meaningEn.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.names),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterNames,
              decoration: InputDecoration(
                hintText: localizations.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = filteredNames[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              '${name.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            name.name,
                            style: TextStyle(
                              fontSize: appProvider.fontSize + 2,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Noor',
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.transliteration,
                                style: TextStyle(
                                  fontSize: appProvider.fontSize - 2,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appProvider.isArabic 
                                    ? name.meaningAr 
                                    : name.meaningEn,
                                style: TextStyle(
                                  fontSize: appProvider.fontSize - 1,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AllahNameDialog(name: name),
                            );
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class AllahNameDialog extends StatelessWidget {
  final AllahName name;

  const AllahNameDialog({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    
    return AlertDialog(
      title: Text(
        name.name,
        style: TextStyle(
          fontSize: appProvider.fontSize + 4,
          fontWeight: FontWeight.bold,
          fontFamily: 'Noor',
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.transliteration,
            style: TextStyle(
              fontSize: appProvider.fontSize,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            appProvider.isArabic ? 'المعنى:' : 'Meaning:',
            style: TextStyle(
              fontSize: appProvider.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appProvider.isArabic ? name.meaningAr : name.meaningEn,
            style: TextStyle(
              fontSize: appProvider.fontSize,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appProvider.isArabic ? 'إغلاق' : 'Close'),
        ),
      ],
    );
  }
}