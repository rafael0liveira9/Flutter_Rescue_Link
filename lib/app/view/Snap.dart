import 'package:flutter/material.dart';
import 'package:flutter_health/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SnapImage extends StatefulWidget {
  const SnapImage({super.key});

  @override
  _SnapImageState createState() => _SnapImageState();
}

class _SnapImageState extends State<SnapImage> {
  late Future<bool> isLoggedFuture;

  @override
  void initState() {
    super.initState();
    isLoggedFuture = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userData');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error loading data... try again later')),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacementNamed('/');
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacementNamed('/login');
          });
        }

        return const LoadingContainer();
      },
    );
  }
}

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: primaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Image(
            width: double.infinity,
            image: AssetImage('assets/images/logo-2.png'),
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
