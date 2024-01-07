import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/bloc/auth_bloc.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

File? _selectedImage;

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

Future<void> _uploadImage(String userId) async {
  if (_selectedImage != null) {
    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$userId.jpg'); // Use the user ID as the file name

    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(_selectedImage!);
    await uploadTask.whenComplete(() => null);

    final String downloadUrl = await storageReference.getDownloadURL();
    print('Imagem enviada com sucesso. URL de download: $downloadUrl');
  } else {
    print('Nenhuma imagem selecionada.');
  }
}

class _CreateState extends State<Create> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool registrationSuccess = false;

  void _showRegistrationSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cadastro realizado com sucesso!'),
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {
            setState(() {
              registrationSuccess = false;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
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
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Insira abaixo suas informações para criar uma conta:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/final-665f5.appspot.com/o/profile_images%2Fdefault_avatar.png?alt=media&token=eda4d9f0-e936-4a51-a7a0-92ea5d22bc9a',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final imagePicker = ImagePicker();
                  final pickedImage =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  setState(() {
                    _selectedImage = pickedImage != null
                        ? File(pickedImage.path)
                        : null;
                  });
                },
                child: const Text('Selecionar Imagem'),
              ),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              hintText: 'Digite seu e-mail',
              labelText: 'Endereço de e-mail',
            ),
            controller: emailController,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.password),
              hintText: 'Digite sua senha',
              labelText: 'Senha',
            ),
            controller: passwordController,
          ),
          Builder(builder: (context) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                final username = emailController.text;
                final password = passwordController.text;
                await _uploadImage(username);

                authBloc.add(
                  RegisterUser(
                    username: username,
                    password: password,
                  ),
                );
                setState(() {
                  registrationSuccess = true;
                });
                _showRegistrationSuccessSnackBar();

              },
              child: const Text(
                'Cadastre-se',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          }),
        ],
      ),
    );
  }
}
