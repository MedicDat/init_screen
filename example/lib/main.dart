import 'package:flutter/material.dart';
import 'package:init_screen/init_screen.dart';

import 'agb.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'init_screen demo',
            home: MyHomePage(),
        );
    }
}

class MyHomePage extends StatefulWidget {

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    final GlobalKey<InitScreenState> _key = GlobalKey();

    _buildAGB() {
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: AGB(),
            ),
        );
    }

    _buildWithCustomNavs() {
        return InitScreen(
            [Text("test"), _buildAGB(), Text("[3]")],
            key: _key, // needed for callback
            customNavButtonBuilder: (index) { // custom NavButton builder
                return IconButton(
                    icon: Icon(Icons.ac_unit),
                    onPressed: () => _key.currentState.navBtnClick(index),
                );
            },
        );
    }

    _buildSimple() {
        return InitScreen(
            [Text("hi"), Text("am"), Text("simple")],
            showNavHelpers: true,
        );
    }

    @override
    Widget build(BuildContext context) {
        return _buildSimple();
    }
}
