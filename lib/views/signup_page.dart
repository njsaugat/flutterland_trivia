// import 'package:flutterland_trivia/views/fade_animation.dart';
import 'package:flutterland_trivia/views/home_screen.dart';
import 'package:flutterland_trivia/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutterland_trivia/models/email_model.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:provider/provider.dart'; // Import the provider package
// import 'package:flutterland_trivia/models/email_model.dart';
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    ));

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: false);
    final CollectionReference _points =
        FirebaseFirestore.instance.collection('points');
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
                          image: AssetImage('images/backgroundSignup.gif'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          // left: 30,
                          // width: 100,
                          // height: 200,
                          // child: Image.asset("assets/bulb.png")),
                          child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/bulb.png'),
                                fit: BoxFit.fill)),
                      )),
                      SizedBox(
                        height: 50,
                      )
                      // //    FadeAnimation(
                      // //       1,

                      // // ),
                      // Positioned(
                      //     left: 140,
                      //     width: 80,
                      //     height: 150,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //               image: AssetImage('images/light-2.png'))),
                      //     )),
                      //   FadeAnimation(
                      //       1.3,

                      // ),
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
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(14, 14, 251, .2),
                                  blurRadius: 10.0,
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
                              child: Text("SignUp"),
                              onPressed: () async {
                                final message =
                                    await AuthService().registration(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                if (message!.contains('Success')) {
                                  await _points.add({
                                    "email": _emailController.text,
                                    "score": 0
                                  });
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
                        height: 70,
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
