import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: Container(
          width: 56,
          height: 56,
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color:
                  Theme.of(context).textTheme.bodyText2.color.withOpacity(0.75),
            ),
            onTap: () {
              // widget.adHandler();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.8,
              // width: MediaQuery.of(context).size.width,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/hint_image.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.065,
            ),
          ],
        ),
      ),
    );
  }
}
