import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home_appbar.dart';
import 'package:flutter_application_2/pages/home_drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Entradas extends StatefulWidget {
  const Entradas({Key? key}) : super(key: key);

  @override
  State<Entradas> createState() => _EntradasState();
}

enum Receita { salario, investimento, transferencia, outros }

double inputValue = 0.0;

class _EntradasState extends State<Entradas> {
  Receita? selectedReceita = Receita.salario;
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
    final entradas = Hive.box('entradas');

    // Initialize the selected type of income based on the value in the Hive box
    if (entradas.get('receita') != null) {
      switch (entradas.get('receita')) {
        case 1:
          selectedReceita = Receita.salario;
          break;
        case 2:
          selectedReceita = Receita.investimento;
          break;
        case 3:
          selectedReceita = Receita.transferencia;
          break;
        case 4:
          selectedReceita = Receita.outros;
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
                offset: const Offset(0, 3),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Insira abaixo o valor:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextFormField(
              initialValue: entradas.get('Entradas'),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: 'Digite o valor',
                labelText: 'Entrada',
              ),
              onChanged: (value) {
                entradas.put('Entradas', value);
                setState(() {
                  inputValue = double.parse(value);
                });
              },
            ),
            Text('Categoria:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Column(children: [
              RadioListTile<Receita>(
                title: const Text("Salário"),
                value: Receita.salario,
                groupValue: selectedReceita,
                onChanged: (Receita? value) {
                  setState(() {
                    selectedReceita = value;
                    entradas.put('receita', 1);
                  });
                },
              ),
              RadioListTile<Receita>(
                title: const Text("Investimento"),
                value: Receita.investimento,
                groupValue: selectedReceita,
                onChanged: (Receita? value) {
                  setState(() {
                    selectedReceita = value;
                    entradas.put('receita', 2);
                  });
                },
              ),
              RadioListTile<Receita>(
                title: const Text("Transferência"),
                value: Receita.transferencia,
                groupValue: selectedReceita,
                onChanged: (Receita? value) {
                  setState(() {
                    selectedReceita = value;
                    entradas.put('receita', 3);
                  });
                },
              ),
              RadioListTile<Receita>(
                title: const Text("Outros"),
                value: Receita.outros,
                groupValue: selectedReceita,
                onChanged: (Receita? value) {
                  setState(() {
                    selectedReceita = value;
                    entradas.put('receita', 4);
                  });
                },
              )
            ]),
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
                      .collection('entradas')
                      .add({
                    'valor': inputValue,
                    'categoria': selectedReceita.toString(),
                    'data': FieldValue.serverTimestamp(),
                  }).then((value){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            'Saldo atualizado! Sua entrada foi de R\$ $inputValue'),
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
                'Adicionar Entrada',
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
