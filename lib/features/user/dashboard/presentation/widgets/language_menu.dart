import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/core/provider/locale_provider.dart';

class LanguageSelectionSheet extends ConsumerWidget {
  const LanguageSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Text(
              getLanguageLetter('en'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text('English'),
          selected: locale!.languageCode == 'en',
          onTap: () {
            ref.read(localeProvider.notifier).state = const Locale('en');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Text(
              getLanguageLetter('hi'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text('Hindi'),
          selected: locale.languageCode == 'hi',
          onTap: () {
            ref.read(localeProvider.notifier).state = const Locale('hi');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Text(
              getLanguageLetter('kn'),
              textAlign: TextAlign.center,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text('Kannada'),
          selected: locale.languageCode == 'kn',
          onTap: () {
            ref.read(localeProvider.notifier).state = const Locale('kn');
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

String getLanguageLetter(String s) {
  switch (s) {
    case 'en':
      return 'A'; // English
    case 'hi':
      return 'ह'; // Hindi
    case 'kn':
      return 'ಕ'; // Kannada
    default:
      return 'E'; // fallback
  }
}
