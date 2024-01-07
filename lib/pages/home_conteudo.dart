import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_appbar.dart';
import 'home_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  double totalDespesas = 0.0;
  double totalEntradas = 0.0;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    fetchTotals();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> fetchTotals() async {
    final currentUser = FirebaseAuth.instance.currentUser;
  
    if (currentUser == null) {
      return;
    }

    final despesasQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('despesas');
    final entradasQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('entradas');

    final despesasSnapshot = await despesasQuery.get();
    final entradasSnapshot = await entradasQuery.get();

    double despesasSum = 0.0;
    double entradasSum = 0.0;

    for (final despesa in despesasSnapshot.docs) {
      despesasSum += despesa.data()['valor'];
    }

    for (final entrada in entradasSnapshot.docs) {
      entradasSum += entrada.data()['valor'];
    }

    setState(() {
      totalDespesas = despesasSum;
      totalEntradas = entradasSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHomeAppBar(),
      drawer: getHomeDrawer(context),
      body: Center(
        child: Container(
          width: 2000,
          height: 2000,
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 20,
                child: Text(
                  '\nSaldo Total\n R\$${(totalEntradas - totalDespesas).toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.white,
                    child: Text(
                      'Total Despesas \n\n R\$${totalDespesas.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 4,
                    thickness: 0.5,
                    indent: 130,
                    endIndent:130,
                    color: Colors.grey,
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.white,
                    child: Text(
                      'Total Entradas \n\n R\$${totalEntradas.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
