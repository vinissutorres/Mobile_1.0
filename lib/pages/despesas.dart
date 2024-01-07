import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home_appbar.dart';
import 'package:flutter_application_2/pages/home_drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Despesas extends StatefulWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  State<Despesas> createState() => _DespesasState();
}

enum Despesa {casa, lazer, alimentacao, transporte, impostos, outros}

double inputValue = 0.0;

class _DespesasState extends State<Despesas> {
  Despesa? selectedDespesa = Despesa.casa;
  late String userId;

  @override
  void initState() {
    super.initState();
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final despesas = Hive.box('despesas');

    // Initialize the selected type of income based on the value in the Hive box
    if (despesas.get('despesa') != null) {
      switch (despesas.get('despesa')) {
        case 1:
          selectedDespesa = Despesa.casa;
          break;
        case 2:
          selectedDespesa = Despesa.lazer;
          break;
        case 3:
          selectedDespesa = Despesa.alimentacao;
          break;
        case 4:
          selectedDespesa = Despesa.transporte;
          break;
        case 5:
          selectedDespesa = Despesa.impostos;
          break;
        case 6:
          selectedDespesa = Despesa.outros;
          break;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Insira abaixo o valor:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            TextFormField(
              initialValue: despesas.get('Despesas'),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: 'Digite o valor',
                labelText: 'Despesa',
              ),
              onChanged: (value) {
                despesas.put('Despesas', value);
                setState(() {
                  inputValue = double.parse(value);
                });
              },
            ),
            Text(
              'Categoria:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Column(
              children: [
                RadioListTile<Despesa>(
                  title: const Text("Casa"),
                  value: Despesa.casa,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 1);
                    });
                  },
                ),
                RadioListTile<Despesa>(
                  title: const Text("Lazer"),
                  value: Despesa.lazer,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 2);
                    });
                  },
                ),
                RadioListTile<Despesa>(
                  title: const Text("Alimentação"),
                  value: Despesa.alimentacao,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 3);
                    });
                  },
                ),
                RadioListTile<Despesa>(
                  title: const Text("Transporte"),
                  value: Despesa.transporte,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 4);
                    });
                  },
                ),
                RadioListTile<Despesa>(
                  title: const Text("Impostos"),
                  value: Despesa.impostos,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 5);
                    });
                  },
                ),
                RadioListTile<Despesa>(
                  title: const Text("Outros"),
                  value: Despesa.outros,
                  groupValue: selectedDespesa,
                  onChanged: (Despesa? value) {
                    setState(() {
                      selectedDespesa = value;
                      despesas.put('Despesa', 6);
                    });
                  },
                )
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (userId.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('despesas')
                      .add({
                    'valor': inputValue,
                    'categoria': selectedDespesa.toString(),
                    'data': FieldValue.serverTimestamp(),
                  }).then((value) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              'Saldo atualizado! Sua despesa foi de R\$ $inputValue'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Erro ao salvar a entrada.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Usuário não autenticado.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Adicionar Despesa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
