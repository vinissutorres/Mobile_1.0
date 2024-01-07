import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/despesas.dart';
import 'package:flutter_application_2/pages/entradas.dart';
import 'package:flutter_application_2/pages/transacoes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/bloc/auth_bloc.dart';
import 'home_conteudo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

Drawer getHomeDrawer(BuildContext context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = _auth.currentUser;
  final storage = FirebaseStorage.instance;
  final profileImageRef = storage.ref().child('profile_images/${currentUser?.email}.jpg');
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.green[100]),
          accountName: Text(currentUser?.displayName ?? ''),
          accountEmail: Text(currentUser?.email ?? ''),
          currentAccountPicture: FutureBuilder<String>(
            future: profileImageRef.getDownloadURL(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  backgroundColor: const Color.fromARGB(0, 158, 158, 158),
                );
              }
              if (snapshot.hasError) {
                return CircleAvatar(
                  backgroundColor: const Color.fromARGB(0, 158, 158, 158),
                );
              }
              return CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data!),
              );
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.home, color: Colors.black),
          title: Text("Home"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePageContent()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.attach_money, color: Colors.green),
          title: Text("Entradas"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Entradas()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.attach_money, color: Colors.red),
          title: Text("Despesas"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Despesas()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.currency_exchange, color: Colors.black),
          title: Text("Transações"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Transacoes()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.black),
          title: Text("Fazer Logout"),
          onTap: () {
            _auth.signOut();
            BlocProvider.of<AuthBloc>(context).add(Logout());
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    ),
  );
}
