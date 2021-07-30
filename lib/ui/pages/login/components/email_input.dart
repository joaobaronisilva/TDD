// @dart=2.10
import 'package:app/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            decoration: InputDecoration(
                errorText:
                    snapshot.data?.isEmpty == true ? null : snapshot.data,
                labelText: 'Email',
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                )),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
