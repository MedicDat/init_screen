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
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal.shade300),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal.shade300,
        accentColor: Colors.teal.shade300,
        toggleableActiveColor: Colors.teal.shade300,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<InitScreenState> _key = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  final ValueNotifier<bool> isDone = ValueNotifier(false);
  bool done = false;

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
      children: [Text("test"), _buildAGB(), Text("[3]")],
      key: _key, // needed for callback
      customNavButtonBuilder: (index) {
        // custom NavButton builder
        return IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () => _key.currentState.navBtnClick(index),
        );
      },
    );
  }

  _buildWithValidator() {
    return InitScreen(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 64, right: 64),
          child: Center(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                validator: (val) {
                  if (val.isEmpty) return "Must not be empty!";
                  return null;
                },
              ),
            ),
          ),
        ),
        Text("Hey you reached me!")
      ],
      validatorKey: _formKey,
    );
  }

  _buildSimple() {
    isDone.addListener(() {
      setState(() {
        done = true;
      });
    });
    if (!done) {
      return InitScreen(
        isDoneNotifier: isDone,
        children: [Text("hi"), Text("am"), Text("simple")],
        //showNavHelpers: true,
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text("done!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSimple();
  }
}
