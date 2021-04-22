
import 'dart:convert';

HeartAssessmentResult heartAssessmentResultFromJson(String str) => HeartAssessmentResult.fromJson(json.decode(str));

String heartAssessmentResultToJson(HeartAssessmentResult data) => json.encode(data.toJson());

class HeartAssessmentResult {
  HeartAssessmentResult({
    required this.sections,
  });

  List<Section> sections;

  factory HeartAssessmentResult.fromJson(Map<String, dynamic> json) => HeartAssessmentResult(
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
  };

}

class Section {
  Section({
    required this.sectionId,
    required this.sectionType,
    required this.answers,
  });

  String sectionId;
  String sectionType;
  List<Answer> answers;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json["sectionId"],
    sectionType: json["sectionType"],
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sectionId": sectionId,
    "sectionType": sectionType,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'SectionId: $sectionId, sectoinType: $sectionType, answers: $answers';
  }
}

class Answer {
  Answer({
    required this.questionId,
    required this.score,
  });

  String questionId;
  int score;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    questionId: json["questionId"],
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "score": score,
  };

  @override
  String toString() {
    return 'questionId: $questionId, score: $score';
  }
}
