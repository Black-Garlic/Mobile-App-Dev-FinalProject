import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/firebase_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _userNameController = TextEditingController();
  final _userNicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            Form (
                key: _formKey,
                child: Consumer<FirebaseState>(
                    builder: (context, appState, _) => Column(
                  children: [
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: '이름',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Username';
                        }
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _userNicknameController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: '닉네임',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Username';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('SIGN UP'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}