import 'package:flutter/material.dart';

class SettingsSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final Function onChange;
  final Color color;

  SettingsSwitchItem({
    this.title,
    this.value,
    this.onChange,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 18,
                    ),
              ),
              SizedBox(
                height: 50,
                width: 60,
                child: Switch(
                  activeColor: color,
                  value: value,
                  onChanged: onChange,
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).iconTheme.color,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
