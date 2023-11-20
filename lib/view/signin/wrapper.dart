import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:janin/view/home/navbar.dart';
import 'package:janin/view/signin/signin.dart';
import 'package:provider/provider.dart';
import 'package:janin/provider/auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder<User?>(
      stream: auth.streamAuthStatus(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.active) {
          return (snapshot.data != null)
              ? Navbar()
              : SignIn();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
