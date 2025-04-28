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
          leading: const Text('🇬🇧'),
          title: const Text('English'),
          selected: locale!.languageCode == 'en',
          onTap: () {
            ref.read(localeProvider.notifier).state = const Locale('en');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Text('🇮🇳'),
          title: const Text('Hindi'),
          selected: locale.languageCode == 'hi',
          onTap: () {
            ref.read(localeProvider.notifier).state = const Locale('hi');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Text('🇮🇳'),
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
