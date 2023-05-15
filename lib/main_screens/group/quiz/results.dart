import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/question_model.dart';

class Resultss extends StatelessWidget {
  final int correct;
  final int incorrect;
  final int total;
  final List<QueryDocumentSnapshot<Object?>> questionSnapshot;

  Resultss({required this.correct, required this.incorrect, required this.total, required this.questionSnapshot});

  QuestionModel getQuestionModelFromDatasnapshot(QueryDocumentSnapshot<Object?> questionSnapshot) {
    Map<String, dynamic> data = questionSnapshot.data() as Map<String, dynamic>;
    return QuestionModel(
      question: data['question'],
      option1: data['option1'],
      option2: data['option2'],
      option3: data['option3'],
      option4: data['option4'],
      correctOption: data['correctOption'] ?? '', // Check if correctOption is not null
      answered: data['answered'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Questions: $total',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Correct Answers: $correct',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Incorrect Answers: $incorrect',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Answers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questionSnapshot.length,
              itemBuilder: (context, index) {
                var question = getQuestionModelFromDatasnapshot(questionSnapshot[index]);
                bool isCorrect = question.correctOption == questionSnapshot[index]['selectedOption'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${question.question}',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Correct Answer: ${question.correctOption}',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Answer: ${isCorrect ? "Correct" : "Incorrect"}',
                      style: TextStyle(fontSize: 16, color: isCorrect ? Colors.green : Colors.red),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}