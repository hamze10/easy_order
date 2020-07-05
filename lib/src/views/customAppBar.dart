import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 110.0;
  final String _title;
  final Color _gradientBegin, _gradientEnd;
  final Widget _leftWidget;
  final Widget _rightWidget;

  CustomAppBar({
    String title,
    Color gradientBegin,
    Color grandientEnd,
    Widget leftWidget,
    Widget rightWidget,
  })  : _title = title,
        _gradientBegin = gradientBegin,
        _gradientEnd = grandientEnd,
        _leftWidget = leftWidget,
        _rightWidget = rightWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            _gradientBegin,
            _gradientEnd,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_leftWidget != null) _leftWidget,
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              _title,
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 5.0,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (_rightWidget != null) _rightWidget,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
