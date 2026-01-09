import 'package:flutter/material.dart';
import 'package:stacks/theme/app_colors.dart';

class CircularPlusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Button pressed");
      },
      child: Container(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, size: 30, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
