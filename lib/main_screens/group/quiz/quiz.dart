import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz_widget.dart';
import 'package:study_up_app/main_screens/group/quiz/result.dart';
import '../../../helper/const.dart';
import 'question_model.dart';

class Quiz extends StatefulWidget {
  final String quizId;
  Quiz(this.quizId);

  @override
  State<Quiz> createState() => _QuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _QuizState extends State<Quiz> {

  QuerySnapshot? questionSnapshot;

  getQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection('QNA')
        .get();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot['question'];

    List<String> options = [
      questionSnapshot['option1'],
      questionSnapshot['option2'],
      questionSnapshot['option3'],
      questionSnapshot['option4'],
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot['option1'];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    getQuizData(widget.quizId).then((val) {
      questionSnapshot = val;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionSnapshot!.docs.length;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 8, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionSnapshot == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizTile(
                          questionModel: getQuestionModelFromDatasnapshot(
                              questionSnapshot!.docs[index]),
                          index: index,
                        );
                      })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Results(
                    correct: _correct, incorrect: _incorrect, total: total),
              ),
            );
          }),
    );
  }
}

class QuizTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizTile({required this.questionModel, required this.index});

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  String optionSelected = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "${widget.index + 1}. ${widget.questionModel.question}",
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                //correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  print('${widget.questionModel.correctOption}');
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: 'A',
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  print('${widget.questionModel.correctOption}');
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: 'B',
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  print('${widget.questionModel.correctOption}');
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: 'C',
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect - 1;
                  _notAttempted = _notAttempted - 1;
                  print('${widget.questionModel.correctOption}');
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: 'D',
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
