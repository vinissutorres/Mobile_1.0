import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

AppBar getHomeAppBar() {
  return AppBar(
    actions: [
      IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout))
    ],
    title: const Center(child: Text("Mundinho das Finanças")),
    backgroundColor: Colors.green,
    //actions: [

    // ]
  );
}
