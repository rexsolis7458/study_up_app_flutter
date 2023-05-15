import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/question_model.dart';
import 'package:study_up_app/main_screens/group/quiz/results.dart';

class Results extends StatelessWidget {
  final int correct;
  final int incorrect;
  final int total;
  final List<QuestionModel> questionList;

  Results(
      {required this.correct,
      required this.incorrect,
      required this.total,
      required this.questionList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Total Questions: $total',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Correct Answers: $correct',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Incorrect Answers: $incorrect',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).popUntil((route) => route.isFirst);
            //   },
            //   child: Text('Back to Home'),
            // ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: questionList.length,
                itemBuilder: (context, index) {
                  return ResultTile(
                    questionModel: questionList[index],
                    index: index,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
