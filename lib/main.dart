import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/bloc/auth_bloc.dart';
import 'package:flutter_application_2/pages/create.dart';
import 'package:flutter_application_2/pages/login.dart';

import 'pages/home_conteudo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDtpuOE5A8CZzCcBTKP-gJCU1S5re7t4pw",
          authDomain: "final-665f5.firebaseapp.com",
          projectId: "final-665f5",
          storageBucket: "final-665f5.appspot.com",
          messagingSenderId: "63691171916",
          appId: "1:63691171916:web:ae7fc02c21469f8e0f2ce9"));

  await Hive.initFlutter();
  await Hive.openBox("entradas");
  await Hive.openBox("despesas");
  runApp(const MyApp());
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SI700',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
          title: 'SI700',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is Authenticated) {
              return const HomePageContent();
            } else {
              return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    body: TabBarView(
                      children: [
                        Login(),
                        Create(),
                      ],
                    ),
                    appBar: AppBar(
                        title:
                            const Center(child: Text("Mundinho das Finanças")),
                        backgroundColor: Colors.green,
                        bottom: TabBar(tabs: [
                          Tab(text: "Efetuar Login"),
                          Tab(text: "Novo Cadastro"),
                        ])),
                  ));
            }
          })),
    );
  }
}
