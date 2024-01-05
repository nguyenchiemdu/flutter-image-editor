import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/data_provider.dart';

class EmojiPickerBottomSheet extends StatefulWidget {
  static String tag = '/EmojiPickerBottomSheet';

  const EmojiPickerBottomSheet({super.key});

  @override
  EmojiPickerBottomSheetState createState() => EmojiPickerBottomSheetState();
}

class EmojiPickerBottomSheetState extends State<EmojiPickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // afterBuildCreated(() => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12)),
          backgroundColor: Colors.white),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Select Emoji', style: boldTextStyle()),
                // 16.height,
                48.height,
                Wrap(
                  children: getSmileys().map(
                    (e) {
                      return Container(
                              padding: const EdgeInsets.all(2),
                              child:
                                  Text(e, style: const TextStyle(fontSize: 35)))
                          .onTap(() {
                        finish(context, e);
                      });
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
          Container(
            decoration: boxDecorationWithRoundedCorners(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Emoji', style: boldTextStyle()),
                const Icon(Icons.clear, color: Colors.black).onTap(() {
                  finish(context);
                })
              ],
            ).paddingSymmetric(horizontal: 8, vertical: 16),
          ),
        ],
      ),
    );
  }
}
