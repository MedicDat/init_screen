library init_screen;

import 'package:flutter/material.dart';

/// An easy to use, multipurpose init screen to introduce your app
class InitScreen extends StatefulWidget {
  final GlobalKey? key;
  final Icon stepIcon;
  final List<Widget> children;

  /// prevent user from going a step back
  final bool noGoBack;

  /// should not be changed
  final int sensitivity;
  final bool showNavButtons;
  final bool showNavHelpers;
  final String navHelperEndText;
  final ValueNotifier<bool>? isDoneNotifier;
  final Icon navHelperIconLeft;
  final Icon navHelperIconRight;
  final Function? customNavButtonBuilder;
  final GlobalKey<FormState>? validatorKey;
  final FloatingActionButtonLocation navBtnLocation;

  InitScreen(
      {required this.children,
      this.key,
      this.stepIcon = const Icon(Icons.circle),
      this.noGoBack = false,
      this.sensitivity = 1000,
      this.showNavButtons = true,
      this.showNavHelpers = false,
      this.navHelperEndText = "Done",
      this.isDoneNotifier,
      this.navHelperIconLeft = const Icon(Icons.chevron_left),
      this.navHelperIconRight = const Icon(Icons.chevron_right),
      this.customNavButtonBuilder,
      this.navBtnLocation = FloatingActionButtonLocation.centerDocked,
      this.validatorKey})
      : super(key: key) {
    assert(navHelperEndText.length < 8);
  }

  @override
  State<StatefulWidget> createState() => InitScreenState();
}

class InitScreenState extends State<InitScreen> {
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
  }

  // build single step button
  _buildStepButton(int index) {
    return widget.customNavButtonBuilder != null
        ? widget.customNavButtonBuilder!(index)
        : IconButton(
            color: Theme.of(context).brightness == Brightness.light
                ? _currentIndex == index
                    ? Colors.grey[800]
                    : Colors.grey
                : _currentIndex == index
                    ? Colors.grey[200]
                    : Colors.grey,
            onPressed: () => navBtnClick(index),
            icon: widget.stepIcon,
          );
  }

  // build step button list
  _buildStepButtonList() {
    return List<Widget>.generate(
        widget.children.length, (index) => _buildStepButton(index));
  }

  // build NavButton container
  _buildNavBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (!widget.noGoBack && widget.showNavHelpers)
          IconButton(
            icon: widget.navHelperIconLeft,
            onPressed: () => navBtnClick(_currentIndex - 1),
          ),
        if (!widget.showNavHelpers &&
            _currentIndex == widget.children.length - 1)
          SizedBox(
            width: 48,
            height: 48,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildStepButtonList(),
        ),
        if (widget.showNavHelpers &&
            _currentIndex != widget.children.length - 1)
          IconButton(
            icon: widget.navHelperIconRight,
            onPressed: () => navBtnClick(_currentIndex + 1),
          ),
        if (_currentIndex == widget.children.length - 1)
          GestureDetector(
            onTap: () => navBtnClick(500),
            child: SizedBox(
              width: 48,
              child: Text(
                widget.navHelperEndText,
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }

  @override
  build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: _userSwiped,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(child: widget.children[_currentIndex]),
          ),
        ),
        floatingActionButtonLocation: widget.navBtnLocation,
        floatingActionButton: widget.showNavButtons ? _buildNavBtnRow() : null,
      ),
    );
  }

  // public callback method
  navBtnClick(int index) {
    if (widget.validatorKey?.currentState?.validate() ?? true) {
      if (widget.noGoBack && index < _currentIndex) return;
      if (index < 0) return;
      if (index != 500) {
        setState(() {
          _currentIndex = index;
        });
        widget.isDoneNotifier?.value = false;
      } else {
        widget.isDoneNotifier?.value = true;
      }
    }
  }

  _userSwiped(DragEndDetails details) {
    // yeah...
    if (widget.validatorKey?.currentState?.validate() ?? true) {
      if (details.primaryVelocity!.abs() < widget.sensitivity) return;
      var newIndex = _currentIndex + (details.primaryVelocity! > 0 ? -1 : 1);
      if (widget.noGoBack && details.primaryVelocity! > 0) return;
      if (newIndex > widget.children.length - 1) return;
      if (newIndex < 0) return;
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }
}
