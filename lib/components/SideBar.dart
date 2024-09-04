import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';

class SideBar extends StatefulWidget {
  final void Function() jobStateOpen;
  final bool? isService;

  const SideBar(
    this.jobStateOpen,
    this.isService,
    Key? key,
  ) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String username = '';
  String email = '';
  String jobStateType = '';
  String stateName = '';
  String initials = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      setState(() {
        username = userData['name'] ?? '';
        email = userData['email'] ?? '';
        jobStateType = userData['jobStateType'] ?? '';
        stateName = userData['stateName'] ?? '';
        initials = getInitials(username);
      });
    }
  }

  String getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length < 2) {
      return '';
    }

    String firstNameInitial = nameParts.first[0];
    String lastNameInitial = nameParts.last[0];

    return '$firstNameInitial$lastNameInitial';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('userData').then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 35.0),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  color: thirdColor,
                ),
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: thirdColor),
              const SizedBox(height: 20),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dados do App',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.app_registration, color: thirdColor),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text('Rescue Link'),
                  SizedBox(height: 2),
                  Text('Version: 1.0.1'),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: thirdColor),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dados de Usuário',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.person, color: thirdColor),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text(username.isNotEmpty ? username : ''),
                  SizedBox(height: 2),
                  Text(email.isNotEmpty ? email : ''),
                  SizedBox(height: 2),
                  Text(jobStateType.isNotEmpty && stateName.isNotEmpty
                      ? '$jobStateType: $stateName'
                      : ''),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: thirdColor),
              const SizedBox(height: 20),
              if (widget.isService == false)
                Column(
                  children: [
                    InkWell(
                      onTap: () => widget.jobStateOpen(),
                      child: Row(
                        children: [
                          Icon(Icons.medical_information, color: accent),
                          SizedBox(width: 10),
                          Text(
                            'Alterar $jobStateType',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: accent),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              InkWell(
                onTap: logout,
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: redUrgency),
                    SizedBox(width: 10),
                    Text(
                      'Sair da conta',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: redUrgency),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
