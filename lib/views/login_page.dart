// import 'package:flutterland_trivia/views/fade_animation.dart';
import 'package:flutterland_trivia/views/home_screen.dart';
import 'package:flutterland_trivia/auth/auth_service.dart';
import 'package:flutterland_trivia/views/signup_page.dart';
import 'package:flutterland_trivia/models/email_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
// import 'models/email_model.dart'; // Import the EmailModel

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ));

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-1.png'))),
                          )),
                      //    FadeAnimation(
                      //       1,

                      // ),
                      Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-2.png'))),
                          )),
                      //   FadeAnimation(
                      //       1.3,

                      // ),
                      Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/clock.png'))),
                          )),
                      //    FadeAnimation(
                      //       1.5,

                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color(0xFF4993FA),
                              Color(0xFF5170FD),
                            ])),
                        child: Center(
                          child: TextButton(
                              child: Text("Login"),
                              onPressed: () async {
                                final message = await AuthService().login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                if (message!.contains('Success')) {
                                  appData
                                      .updateUserEmail(_emailController.text);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                  ),
                                );
                              },
                              // onPressed: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomePage()),
                              //   );
                              // },
                              style: ButtonStyle(
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)))),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Text(
                      //   "Forgot Password?",
                      //   style: TextStyle(color: Color(0xFF4993FA)),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: Text('Signup'),
                        // color: Color(0xFF4993FA),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
