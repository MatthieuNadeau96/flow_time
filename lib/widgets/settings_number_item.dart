import 'package:flutter/material.dart';

class SettingsNumberItem extends StatelessWidget {
  final String title;
  final String numberText;
  final Color color;
  final Function onTap;

  SettingsNumberItem({
    this.title,
    this.numberText,
    this.color,
    this.onTap,
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
                child: GestureDetector(
                  onTap: onTap,
                  child: Center(
                    child: Text(
                      numberText,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
