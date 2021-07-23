import 'package:app/ui/components/components.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginHeader(),
          HeadLine1(
            text: 'Login',
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColorLight,
                        )),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          icon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColorLight)),
                      obscureText: true,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Entrar'.toUpperCase()),
                  ),
                  FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      label: Text('Criar conta'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
