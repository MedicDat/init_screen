# init_screen

An easy-to-use, multipurpose init screen to introduce your app
## Example usage

The most basic example would be to return the InitScreen class, for example in your login activity:

```dart
@override
build(BuildContext context) {
    return InitScreen([Text("hi"), Text("am"), Text("sample content")]);
}

```

This creates an init screen and displays its three children.  
You can throw in any Widget you like but be aware that InitScreen just centers them.  
You must supply a layout yourself.

## Modification
You can change a lot of behavior and stuff surrounding the InitScreen class.  
For a complete list please see the InitScreen class.

But here,s an example of how to change the NavButtons:

```dart
class MyInitScreen extends State<MyHomePage> {

    // that one is important! Don't miss out that the GlobalKey must be for InitScreenState
    final GlobalKey<InitScreenState> _key = GlobalKey();

    _buildWithCustomNavs() {
        return InitScreen(
            // children to display
            [Text("test"), Text("[3]")],
            key: _key, // needed for callback
            customNavButtonBuilder: (index) { // custom NavButton builder
                return IconButton(
                    icon: Icon(Icons.ac_unit),
                    // must use the public callback
                    onPressed: () => _key.currentState.navBtnClick(index),
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return _buildWithCustomNavs();
    }
}
```