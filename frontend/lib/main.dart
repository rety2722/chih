import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => Register()},
    ));

class Register extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чих Пых - Регистрация'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Эл. почта', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Пожалуйста, введите электронную почту";
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Фамилия', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Пожалуйста, введите фамилию";
                    }
                    return null;
                  },
                  controller: _lastNameController,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Имя', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Пожалуйста, введите имя";
                    }
                    return null;
                  },
                  controller: _firstNameController,
                ),
                SizedBox(height: 16),
                TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Пароль', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Пожалуйста, введите пароль";
                      }
                      return null;
                    },
                    controller: _passwordController),
                SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Валидация прошла успешно, отправляем запрос на сервер
                          try {
                            final response = await sendRegistrationRequest(
                                _emailController.text,
                                _lastNameController.text,
                                _firstNameController.text,
                                _passwordController.text);
                            final token = response['token']; // TODO

                            // // Сохраняем токен (например, в SharedPreferences)
                            // saveTokenLocally(token);
                            print(token);

                            // Другие действия после успешной регистрации
                          } catch (error) {
                            // Обработка ошибок (например, вывод сообщения об ошибке)
                            print('Ошибка при регистрации: $error');
                          }
                        }
                      },
                      child: Text('Зарегистрироваться'),
                    ),
                    TextButton(onPressed: () {}, child: Text('Войти')),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
