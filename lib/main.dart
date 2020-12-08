import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(
        title: 'Biometrics',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = 'Not Authorised';
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometrics() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    } else {
      setState(() {
        _canCheckBiometric = canCheckBiometric;
      });
    }
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometric;
    try {
      listOfBiometric = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    } else {
      setState(() {
        _availableBiometricTypes = listOfBiometric;
      });
    }
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Please authenticate to complete your transaction.",
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    } else {
      setState(() {
        if (isAuthorized = true) {
          _authorizedOrNot = 'Authorized';
        } else {
          _authorizedOrNot = 'Not Authorized';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Can we check biometric: $_canCheckBiometric'),
            RaisedButton(
              onPressed: _checkBiometrics,
              child: Text('Check Biometric'),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
            Text('List of Biometric: ${_availableBiometricTypes.toString()}'),
            RaisedButton(
              onPressed: _getListOfBiometricTypes,
              child: Text('List of Biometric Types'),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
            Text('Authorised: $_authorizedOrNot'),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Text('Authorize Now'),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
          ],
        ),
      ),
    );
  }
}
