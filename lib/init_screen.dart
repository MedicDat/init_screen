library init_screen;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// An easy to use, multipurpose init screen to introduce your app
class InitScreen extends StatefulWidget{

    final GlobalKey key;
    final Icon stepIcon;
    final List<Widget> children;
    /// prevent user from going a step back
    final bool noGoBack;
    /// should not be changed
    final int sensitivity;
    final bool showNavHelpers;

    /// those two must not be true at the same time
    final bool showNavButtons;
    final bool showNavBar;

    final String navHelperEndText;
    final Icon navHelperIconLeft;
    final Icon navHelperIconRight;
    final Function customNavButtonBuilder;
    final Color backgroundColor;
    /// color of the static nav bar
    final Color barColor;
    final Color navBtnFocusedColor;
    final Color navBtnUnfocusedColor;
    final GlobalKey<FormState> validatorKey;
    final FloatingActionButtonLocation navBtnLocation;

    InitScreen({
        @required this.children,
        this.key,
        this.stepIcon = const Icon(MdiIcons.circle),
        this.noGoBack = false,
        this.sensitivity = 1000,
        this.showNavButtons = true,
        this.showNavHelpers = false,
        this.showNavBar = false,
        this.navHelperEndText = "DONE",
        this.navHelperIconLeft = const Icon(Icons.chevron_left),
        this.navHelperIconRight = const Icon(Icons.chevron_right),
        this.customNavButtonBuilder,
        this.backgroundColor = Colors.transparent,
        this.barColor = Colors.black,
        this.navBtnFocusedColor = Colors.white,
        this.navBtnUnfocusedColor = Colors.grey,
        this.navBtnLocation = FloatingActionButtonLocation.centerDocked,
        this.validatorKey
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() => InitScreenState(
        this.children,
        this.stepIcon,
        this.noGoBack,
        this.sensitivity,
        this.showNavButtons,
        this.showNavHelpers,
        this.showNavBar,
        this.navHelperEndText,
        this.navHelperIconLeft,
        this.navHelperIconRight,
        this.customNavButtonBuilder,
        this.backgroundColor,
        this.barColor,
        this.navBtnFocusedColor,
        this.navBtnUnfocusedColor,
        this.navBtnLocation,
        this.validatorKey);

}

class InitScreenState extends State<InitScreen> {

    final Icon _stepIcon;
    final List<Widget> _children;
    final bool _noGoBack;
    final int _sensitivity;
    final bool _showNavButtons;
    final bool _showNavHelpers;
    final bool _showNavBar;
    final String _navHelperEndText;
    final Icon _navHelperIconLeft;
    final Icon _navHelperIconRight;
    final Function _customNavButtonBuilder;
    final Color _backgroundColor;
    final Color _barColor;
    final Color _navBtnFocusedColor;
    final Color _navBtnUnfocusedColor;
    final FloatingActionButtonLocation _navBtnLocation;
    final GlobalKey<FormState> _validator;
    int _currentIndex = 0;

    InitScreenState(
        this._children,
        this._stepIcon,
        this._noGoBack,
        this._sensitivity,
        this._showNavButtons,
        this._showNavHelpers,
        this._showNavBar,
        this._navHelperEndText,
        this._navHelperIconLeft,
        this._navHelperIconRight,
        this._customNavButtonBuilder,
        this._backgroundColor,
        this._barColor,
        this._navBtnFocusedColor,
        this._navBtnUnfocusedColor,
        this._navBtnLocation,
        this._validator)
        : assert(_navHelperEndText.length < 8), assert(!(_showNavBar && _showNavButtons));

    // build single step button
    _buildStepButton(int index) {
        return _customNavButtonBuilder != null ? _customNavButtonBuilder(index) : IconButton(
            color: _currentIndex == index ? _navBtnFocusedColor : _navBtnUnfocusedColor,
            onPressed: () => navBtnClick(index),
            icon: _stepIcon,
        );
    }

    // build step button list
    _buildStepButtonList() {
        return List<Widget>.generate(
            _children.length,
            (index) => _buildStepButton(index)
        );
    }

    // build NavButton container
    _buildNavBtnRow() {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                if (!_noGoBack && _showNavHelpers)
                    SizedBox(
                        width: 40,
                        child: IconButton(
                            icon: _navHelperIconLeft,
                            onPressed: () => navBtnClick(_currentIndex - 1),
                        )
                    )
                else
                    SizedBox(
                        width: 30,
                    ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildStepButtonList(),
                ),
                if (_showNavHelpers)
                    if (_currentIndex == _children.length - 1)
                        SizedBox(
                            width: 40,
                            child: Text(_navHelperEndText),
                        )
                    else
                        SizedBox(
                            width: 40,
                            child: IconButton(
                                icon: _navHelperIconRight,
                                onPressed: () => navBtnClick(_currentIndex + 1),
                            ),
                        )
                else
                    SizedBox(
                        width: 40,
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
                        child: Container(
                            color: _backgroundColor,
                            child: Stack(
                                children: [
                                    Center(
                                        child: _children[_currentIndex]
                                    ),
                                    if (!_showNavButtons && _showNavBar)
                                        Positioned(
                                            bottom: 0,
                                            child: Container(
                                                color: _barColor,
                                                height: 56,
                                                width: MediaQuery.of(context).size.width,
                                                child: _buildNavBtnRow()
                                            ),
                                        )
                                ],
                            ),
                        ),
                    ),
                ),
                floatingActionButtonLocation: _navBtnLocation,
                floatingActionButton: _showNavButtons && !_showNavBar ?
                _buildNavBtnRow() :
                null
                ,
            ),
        );
    }

    // public callback method
    navBtnClick(int index) {
        if (_validator?.currentState?.validate() ?? true) {
            if (_noGoBack && index < _currentIndex)
                return;
            setState(() {
                _currentIndex = index;
            });
        }
    }

    _userSwiped(DragEndDetails details) {
        // yeah...
        if (_validator?.currentState?.validate() ?? true) {
            if (details.primaryVelocity.abs() < _sensitivity)
                return;
            var newIndex = _currentIndex + (details.primaryVelocity > 0 ? -1 : 1);
            if (_noGoBack && details.primaryVelocity > 0)
                return;
            if (newIndex > _children.length - 1)
                return;
            if (newIndex < 0)
                return;
            setState(() {
                _currentIndex = newIndex;
            });
        }
    }

}
