import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgraderReleaseNotesBottomSheet {
  const UpgraderReleaseNotesBottomSheet({
    BuildContext? context,
    Color? backgroundColor,
    double bottomSheetMaxHeightFactor = 0.6,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetTitleTextStyle,
    TextStyle? bottomSheetReleaseNotesTextStyle,
  });

  static void showBottomSheet({
    required BuildContext context,
    Color? backgroundColor,
    double bottomSheetMaxHeightFactor = 0.6,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetTitleTextStyle,
    TextStyle? bottomSheetReleaseNotesTextStyle,
  }) async {
    print('upgrader: _showBottomSheet');

    final Locale locale = Localizations.localeOf(context);
    print('upgrader: locale: $locale');
    print('upgrader: countryCode: ${locale.countryCode}');
    print('upgrader: languageCode: ${locale.languageCode}');

    Upgrader upgrader = Upgrader();
    // TODO: locale.countryCode and locale.languageCode should be used:
    // Upgrader upgrader = Upgrader(countryCode: locale.countryCode, languageCode: locale.languageCode);

    await upgrader.initialize();

    final versionInfo = await upgrader.updateVersionInfo();
    final releaseNotes = versionInfo?.releaseNotes;

    if (context.mounted) {
      await showModalBottomSheet(
        backgroundColor: bottomSheetBackgroundColor ?? Colors.white,
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext c) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    bottomSheetMaxHeightFactor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 20, left: 20, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // TODO: locale.languageCode should be used: Current issue is that this does not change when the language is changed.
                        UpgraderMessages(code: 'da').newInThisVersion,
                        style: bottomSheetTitleTextStyle ??
                            const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        top: 10, right: 20, left: 20, bottom: 50),
                    child: Text(
                      style: bottomSheetReleaseNotesTextStyle ??
                          const TextStyle(fontSize: 14),
                      releaseNotes ??
                          // TODO: locale.languageCode should be used:
                          UpgraderMessages(code: 'da').noAvailableReleaseNotes,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
