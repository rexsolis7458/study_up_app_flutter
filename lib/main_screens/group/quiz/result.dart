import 'package:flutter/material.dart';
import '../../../helper/const.dart';
import 'question_model.dart';

class Results extends StatefulWidget {
  final int questionSnapshot, correct, incorrect, total;
  Results({
    required this.questionSnapshot,
    required this.correct,
    required this.incorrect,
    required this.total,
  });
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late final QuestionModel questionModel;
  late final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: BGColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.correct}/${widget.total}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "You answered ${widget.correct} answers correctly and"
                      "${widget.incorrect} answers incorrectly",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: ButtonColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
