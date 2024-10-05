import 'package:chat_app_task/const/consts.dart';
import 'package:chat_app_task/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TitleBuilder extends StatefulWidget {
  final String text;
  final double fontSize;
  final double padding;
  final bool isRequired;
  final String? hint;

  const TitleBuilder({
    required this.text,
    this.fontSize = 14,
    this.padding = 15,
    this.isRequired = false,
    this.hint,
    super.key,
  });

  @override
  State<TitleBuilder> createState() => _TitleBuilderState();
}

class _TitleBuilderState extends State<TitleBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.padding.h),
      child: Row(
        children: [
          Text(widget.text, style: _style),
          (widget.hint != null ? 5 : 10).width,
          widget.isRequired
              ? Text(
                  '*',
                  style: _style.copyWith(
                    color: failColor,
                    fontSize: (widget.fontSize + 3).sp,
                  ),
                )
              : empty,
          widget.hint != null
              ? Text(
                  widget.hint!,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : empty,
        ],
      ),
    );
  }

  TextStyle get _style => TextStyle(
        fontSize: widget.fontSize.sp,
        fontWeight: FontWeight.w500,
      );
}
