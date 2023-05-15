import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/question_model.dart';

class ResultTile extends StatelessWidget {
  final QuestionModel questionModel;
  final int index;

  ResultTile({required this.questionModel, required this.index});

  @override
  Widget build(BuildContext context) {
    var answeredOption = questionModel.answeredOption;
    var correctOption = questionModel.correctOption;
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}: ${questionModel.question}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 16),
            // Text(
            //   "Your answer: ${answeredOption ?? "-"}",
            //   style: const TextStyle(fontSize: 16),
            // ),
            const SizedBox(height: 8),
            Text(
              "Correct answer: $correctOption",
              style: TextStyle(fontSize: 16),
            ),
            // const SizedBox(height: 8),
            // if (questionModel.isCorrect)
            //   const Text(
            //     "You got it right!",
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.green,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // if (!questionModel.isCorrect)
            //   const Text(
            //     "You got it wrong!",
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.red,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
