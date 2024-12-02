import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgraderReleaseNotesBottomSheet {
  const UpgraderReleaseNotesBottomSheet({
    BuildContext? context,
    String? languageCode,
    Color? backgroundColor,
    double bottomSheetMaxHeightFactor = 0.6,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetTitleTextStyle,
    TextStyle? bottomSheetReleaseNotesTextStyle,
  });

  static void showBottomSheet({
    required BuildContext context,
    required String languageCode,
    Color? backgroundColor,
    double bottomSheetMaxHeightFactor = 0.6,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetTitleTextStyle,
    TextStyle? bottomSheetReleaseNotesTextStyle,
  }) async {
    Upgrader upgrader = Upgrader(languageCode: languageCode);

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
                        UpgraderMessages(code: languageCode).newInThisVersion,
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
                          UpgraderMessages(code: languageCode)
                              .noAvailableReleaseNotes,
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
