import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';

class InfoDialog extends StatelessWidget {
  final String title, subTitle;
  final String? closeText;
  final VoidCallback? onClose;

  const InfoDialog({
    Key? key,
    required this.title,
    this.subTitle = "",
    this.closeText,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget child;
    final _title = Text(
      title,
    );
    final _subTitle = subTitle.isNotEmpty
        ? Text(
            subTitle,
          )
        : null;

    final btn = TextButton(
      child: Text(closeText ?? LocaleKeys.misc_close.tr),
      onPressed: _onDialogClose,
    );
    child = AlertDialog(
      title: _title,
      content: _subTitle,
      actions: [btn],
    );
    return child;
  }

  _onDialogClose() {
    if (onClose != null) onClose!();
    Get.back();
  }

  Future<void> show() => Get.dialog(this);
}
