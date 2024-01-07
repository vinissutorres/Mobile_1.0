import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/pages/home_appbar.dart';
import 'package:flutter_application_2/pages/home_drawer.dart';
import 'package:intl/intl.dart';

class Transacoes extends StatefulWidget {
  const Transacoes({Key? key}) : super(key: key);

  @override
  State<Transacoes> createState() => _TransacoesState();
}

class _TransacoesState extends State<Transacoes> {
Future<void> _confirmarExclusao(String documentId, String collectionName) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Excluir transação'),
        content: Text('Deseja realmente excluir esta transação?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Não'),
          ),
          TextButton(
            onPressed: () {
              // Excluir a transação do Firebase
              FirebaseFirestore.instance.collection(collectionName).doc(documentId).delete();
              Navigator.of(context).pop();
            },
            child: Text('Sim'),
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHomeAppBar(),
      drawer: getHomeDrawer(context),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        width: 2000,
        height: 2000,
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
        child: Column(
          children: [
            Text(
              'Entradas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('entradas').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erro ao carregar os dados de entradas.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data!.docs[index];
                    var entrada = document.data() as Map<String, dynamic>;
                    var valor = entrada['valor'];
                    var categoria = entrada['categoria'].toString().split('.')[1];;
                    var data = entrada['data'] as Timestamp;

                    var transformData = DateFormat('dd/MM/yyyy HH:mm');
                    var newData = transformData.format(data.toDate());

                    return ListTile(
                      title: Text('$newData - $categoria : $valor'),
                      onTap: () {
                        _confirmarExclusao(document.id, 'entradas');;
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Despesas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('despesas').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erro ao carregar os dados de despesas.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data!.docs[index];
                    var despesa = document.data() as Map<String, dynamic>;
                    var valor = despesa['valor'];
                    var categoria = despesa['categoria'].toString().split('.')[1];
                    var data = despesa['data'] as Timestamp;
                    var transformData = DateFormat('dd/MM/yyyy HH:mm');
                    var newData = transformData.format(data.toDate());

                    return ListTile(
                      title: Text('$newData - $categoria : $valor'),
                      onTap: () {
                       _confirmarExclusao(document.id, 'despesas');
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
