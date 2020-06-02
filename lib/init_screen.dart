library init_screen;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// An easy to use, multipurpose init screen to introduce your app
class InitScreen extends StatefulWidget{

    final Icon stepIcon;
    final List<Widget> children;

    InitScreen(this.children, {this.stepIcon = const Icon(MdiIcons.circleSlice8)});

    @override
    State<StatefulWidget> createState() => InitScreenState(this.children, this.stepIcon);

}

class InitScreenState extends State<InitScreen> {

    final Icon _stepIcon;
    final List<Widget> _children;
    int _currentIndex = 0;

    InitScreenState(this._children, this._stepIcon);

    @override
    initState() {
        super.initState();
    }

    /// build single step button
    _buildStepButton(int index) {
        return IconButton(
            color: _currentIndex == index ? Colors.grey[700] : Colors.grey[500],
            onPressed: () {
                setState(() {
                    _currentIndex = index;
                });
            },
            icon: _stepIcon,
        );
    }

    /// build step button list
    _buildStepButtonList() {
        return List<Widget>.generate(
            _children.length,
            (index) => _buildStepButton(index)
        );
    }

    @override
    build(BuildContext context) {
        return Scaffold(
            body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: _userSwiped,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: _children[_currentIndex]
                    ),
                ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildStepButtonList(),
            ),
        );
    }

    _userSwiped(DragEndDetails details) {
        var newIndex = _currentIndex + (details.primaryVelocity > 0 ? 1 : -1);
        if (newIndex > _children.length - 1)
            return;
        if (newIndex < 0)
            return;
        setState(() {
            _currentIndex = newIndex;
        });
    }

}
