import 'package:flutterland_trivia/models/flutter_topics_model.dart';
import 'package:flutterland_trivia/views/flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterland_trivia/views/login_page.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:flutterland_trivia/models/email_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Score extends StatelessWidget {
  Future<QuerySnapshot> getScoreData(email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('points')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    const Color bgColor = Color(0xFF4993FA);

    return FutureBuilder<QuerySnapshot>(
      future: getScoreData(appData.userEmail),
      builder: (context, snapshot) {
        print(snapshot);
        print('data ${snapshot.data.toString()}');
        int score = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('here');
          return Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: EdgeInsets.only(top: 10, bottom: 0),
                child: CircularProgressIndicator()
                // Text(
                //   'Score: $score', // Use the extracted score value
                //   style: TextStyle(color: Colors.white),
                // ),
                ),
          );
          // Show loading indicator while data is loading
        }

        if (!snapshot.hasData
            // || !snapshot.data!.exists
            ||
            snapshot.data!.docs.isEmpty) {
          print('hasData');

          return Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.only(top: 10, bottom: 0),
              child: Text(
                'Score: ${0}', // Use the extracted score value
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          // Text('No data available.');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          QueryDocumentSnapshot document = snapshot.data!.docs[0];
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          // return Text('Hello');
          score = data['score'];
        }

        // Extract the score value from the document snapshot
        // int score = snapshot.data!.get('score');
        print(snapshot.data);
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.only(top: 10, bottom: 0),
            child: Text(
              'Score: $score', // Use the extracted score value
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final Color bgColor3 = Color(0xFF5170FD);

  Future<void> _deleteScoreHistory(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('points')
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
    print(documentSnapshot);
    // Update the document data
    await documentSnapshot.reference.update({
      "score": 0,
    });
  }

  Future<void> _deleteAccountByEmail(String email) async {
    try {
      // Fetch user data with the provided email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('points')
          .where('email', isEqualTo: email)
          .get();
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      await documentSnapshot.reference.delete();

      var usersQuery =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // Check if the email is associated with any account
      if (usersQuery.isNotEmpty) {
        String userUID =
            usersQuery.first; // Assuming there's only one associated UID

        // Delete Firestore data associated with the user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUID)
            .delete();

        // Delete user's authentication record
        await FirebaseAuth.instance.currentUser?.delete();

        // You can navigate to a success screen or log the user out here
      } else {
        // No user found with the provided email
        print("No user found with this email");
      }
    } catch (e) {
      print("Error deleting account: $e");
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: bgColor3,
            ),
            child: Text(
              'Flutterland Trivia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Navigate to home screen or perform an action
              appData.userEmail = '';
              print(appData.userEmail);
              // Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Delete Score History'),
            onTap: () async {
              await _deleteScoreHistory(appData.userEmail);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete User'),
            onTap: () async {
              // Navigate to settings screen or perform an action
              // Navigator.pop(context); // Close the drawer
              await _deleteAccountByEmail(appData.userEmail);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    const Color bgColor = Color(0xFF4993FA);
    const Color bgColor3 = Color(0xFF5170FD);
    final CollectionReference _points =
        FirebaseFirestore.instance.collection('points');
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: bgColor3,
      //   title: Text('FlutterLand Trivia'),
      //   leading: Builder(
      //     builder: (context) => IconButton(
      //       icon: Icon(Icons.menu),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer(); // This will work correctly now
      //       },
      //     ),
      //   ),
      // ),
      drawer: DrawerWidget(),
      backgroundColor: bgColor3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context)
                          .openDrawer(); // This will work correctly now
                    },
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-1.0, -42.0),
                child: Score(),
              ),
              // Score(),
              Container(
                decoration: BoxDecoration(
                  color: bgColor3,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.24),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                      spreadRadius: -10,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                ),
                child: Image.asset("assets/dash.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Flutterland ",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: 21,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      for (var i = 0; i < "Trivia!!!".length; i++) ...[
                        TextSpan(
                          text: "Trivia!!!"[i],
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 21 + i.toDouble(),
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: flutterTopicsList.length,
                itemBuilder: (context, index) {
                  final topicsData = flutterTopicsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewCard(
                            typeOfTopic: topicsData.topicQuestions,
                            topicName: topicsData.topicName,
                          ),
                        ),
                      );
                      print(topicsData.topicName);
                    },
                    child: Card(
                      color: bgColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              topicsData.topicIcon,
                              color: Colors.white,
                              size: 55,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              topicsData.topicName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
