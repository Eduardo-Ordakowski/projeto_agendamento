import 'package:flutter/material.dart';
import 'package:projeto_agendamento/Widgets/login_field.dart';
import 'package:projeto_agendamento/Widgets/social_button.dart';
import 'package:projeto_agendamento/pallete.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Palette.mainColor1),
              ),
              SizedBox(height: 50),
                SocialButton(
                  iconName: 'g_logo',
                  label: 'Login com Google',
                  horizontalPadding: 80,
                  onPressed: () {},
                ),
              SizedBox(height: 20),
                SocialButton(
                  iconName: 'f_logo',
                  label: 'Login com Facebook',
                  onPressed: () {},
                ),
              SizedBox(height: 20),
                const Text('OU', style: TextStyle(fontSize: 17, color: Palette.mainColor1),
              ),
              SizedBox(height: 20,),
                LoginField(hintText: 'Email'),
              SizedBox(height: 20,),
                LoginField(hintText: 'Senha'),
            ],
          ),
        ),
      ),
    );
  }
}
