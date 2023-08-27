import 'package:flutterland_trivia/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:flutterland_trivia/models/email_model.dart';
import 'package:flutterland_trivia/views/home_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(
      {super.key,
      required this.score,
      required this.totalQuestions,
      required this.whichTopic});
  final int score;
  final int totalQuestions;
  final String whichTopic;
  Future<QuerySnapshot> getScoreData(email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('points')
        .where('email', isEqualTo: email)
        .get();

    return snapshot;
  }

  Future<void> updatePoints(_points, email) async {
    QuerySnapshot querySnapshot =
        await _points.where("email", isEqualTo: email).get();
    if (querySnapshot.size > 0) {
      // There should be only one document with the given email
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      final previousScore = documentSnapshot.get('score');
      print('previousScore ${previousScore}');
      print(documentSnapshot);
      // Update the document data
      await documentSnapshot.reference.update({
        "score": score + previousScore,
      });
    } else {
      // Document with the specified email not found
      print("Document with email ${email} not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    const Color bgColor3 = Color(0xFF5170FD);
    print(score);
    final CollectionReference _points =
        FirebaseFirestore.instance.collection('points');
    // await _points.add({"email": appData.userEmail, "price": score});
    print(totalQuestions);
    print("this is the user email");
    print(appData.userEmail);
    final double percentageScore = (score / totalQuestions) * 100;
    final int roundedPercentageScore = percentageScore.round();
    const Color cardColor = Color(0xFF4993FA);
    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, (route) => route.isFirst);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: bgColor3,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await updatePoints(_points, appData.userEmail);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: bgColor3,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Results On Your ",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                    ),
                    for (var i = 0; i < "Riddles!!!".length; i++) ...[
                      TextSpan(
                        text: "Riddles!!!"[i],
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: 18 + i.toDouble(),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                    ]
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  whichTopic.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              ResultsCard(
                  roundedPercentageScore: roundedPercentageScore,
                  bgColor3: bgColor3),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(cardColor),
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.sizeOf(context).width * 0.80, 40),
                  ),
                  elevation: MaterialStateProperty.all(4),
                ),
                onPressed: () async {
                  await updatePoints(_points, appData.userEmail);
                  // Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: const Text(
                  "Take another test",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
