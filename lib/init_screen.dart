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
    final bool showNavButtons;
    final Function customNavButtonBuilder;
    final Color backgroundColor;
    final FloatingActionButtonLocation navBtnLocation;

    InitScreen(this.children, {
        this.key,
        this.stepIcon = const Icon(MdiIcons.circleSlice8),
        this.noGoBack = false,
        this.sensitivity = 1000,
        this.showNavButtons = true,
        this.customNavButtonBuilder,
        this.backgroundColor = Colors.transparent,
        this.navBtnLocation = FloatingActionButtonLocation.centerDocked
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() => InitScreenState(this.children, this.stepIcon,
                                                this.noGoBack, this.sensitivity, this.showNavButtons,
                                                this.customNavButtonBuilder, this.backgroundColor,
                                                this.navBtnLocation);

}

class InitScreenState extends State<InitScreen> {

    final Icon _stepIcon;
    final List<Widget> _children;
    final bool _noGoBack;
    final int _sensitivity;
    final bool _showNavButtons;
    final Function _customNavButtonBuilder;
    final Color _backgroundColor;
    final FloatingActionButtonLocation _navBtnLocation;
    int _currentIndex = 0;

    InitScreenState(this._children, this._stepIcon, this._noGoBack,
        this._sensitivity, this._showNavButtons, this._customNavButtonBuilder,
        this._backgroundColor ,this._navBtnLocation);

    @override
    initState() {
        super.initState();
    }

    // build single step button
    _buildStepButton(int index) {
        return _customNavButtonBuilder != null ? _customNavButtonBuilder(index) : IconButton(
            color: _currentIndex == index ? Colors.grey[700] : Colors.grey,
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
                            child: Center(
                                child: _children[_currentIndex]
                            ),
                        ),
                    ),
                ),
                floatingActionButtonLocation: _navBtnLocation,
                floatingActionButton: _showNavButtons ?
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildStepButtonList(),
                ) :
                null
                ,
            ),
        );
    }

    // public callback method
    navBtnClick(int index) {
        if (_noGoBack && index < _currentIndex)
            return;
        setState(() {
            _currentIndex = index;
        });
    }

    _userSwiped(DragEndDetails details) {
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
