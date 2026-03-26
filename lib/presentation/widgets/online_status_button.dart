import 'package:flutter/cupertino.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class OnlineStatusButton extends StatefulWidget {
  const OnlineStatusButton({super.key, this.value = false, this.onChanged});

  final bool value;

  final Function(bool value)? onChanged;

  @override
  State<OnlineStatusButton> createState() => _OnlineStatusButtonState();
}

class _OnlineStatusButtonState extends State<OnlineStatusButton> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OnlineStatusButton oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        _value = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        spacing: AppSpacings.s4,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            _value ? 'Online' : 'Away',
            type: AppTextType.t12sb,
            color: _value ? AppColors.online : AppColors.offline,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CupertinoSwitch(
              value: _value,
              onChanged: (value) {

                setState(() {
                  _value = value;
                });
                widget.onChanged?.call(value);
              },
              inactiveTrackColor: AppColors.offline,
              activeTrackColor: AppColors.online,
            ),
          ),
        ],
      ),
    );
  }
}
