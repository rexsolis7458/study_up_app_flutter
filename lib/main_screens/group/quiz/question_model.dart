class QuestionModel {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;
  bool answered;
  String? answeredOption; // added this
  bool get isCorrect => answeredOption == correctOption; // added this

  QuestionModel({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
    this.answered = false,
    this.answeredOption, // added this
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      correctOption: map['correctOption'],
      answered: map['answered'] ?? false,
    );
  }
}
