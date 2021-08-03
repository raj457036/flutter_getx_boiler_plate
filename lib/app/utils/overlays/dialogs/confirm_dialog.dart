import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';

class ConfirmDialog extends StatelessWidget {
  final String title, subTitle;
  final String? yesText;
  final String? noText;
  final TextAlign? textAlign;

  const ConfirmDialog({
    Key? key,
    required this.title,
    this.subTitle = "",
    this.yesText,
    this.noText,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget child;
    final _title = Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w400,
      ),
      textAlign: textAlign,
    );
    final _subTitle = subTitle.isNotEmpty
        ? Text(
            subTitle,
            textAlign: textAlign,
          )
        : null;

    final yesBtn = Flexible(
      child: TextButton(
        child: Text(yesText ?? LocaleKeys.misc_yes.tr),
        onPressed: () => _onDialogClose(true),
      ),
    );

    final noBtn = Flexible(
      child: TextButton(
        child: Text(noText ?? LocaleKeys.misc_no.tr),
        onPressed: () => _onDialogClose(false),
      ),
    );
    child = AlertDialog(
      // titlePadding: const EdgeInsets.only(right: 0),
      title: _title,
      content: _subTitle,
      actions: [
        Row(
          children: [noBtn, SizedBox(width: 10.0), yesBtn],
        )
      ],
    );
    return child;
  }

  _onDialogClose(bool action) {
    Get.back(result: action);
  }

  Future<bool> show() async => (await Get.dialog(this)) ?? false;
}
