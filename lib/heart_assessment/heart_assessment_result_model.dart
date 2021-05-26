
import 'dart:convert';

HeartAssessmentResult heartAssessmentResultFromJson(String str) => HeartAssessmentResult.fromJson(json.decode(str));

String heartAssessmentResultToJson(HeartAssessmentResult data) => json.encode(data.toJson());

class HeartAssessmentResult {
  HeartAssessmentResult({
    required this.sections,
    required this.totalSections
  });

  List<Section> sections;
  int totalSections;

  factory HeartAssessmentResult.fromJson(Map<String, dynamic> json) => HeartAssessmentResult(
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
    totalSections: json['totalSections']
  );

  Map<String, dynamic> toJson() => {
    "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
    "totalSections": totalSections
  };

  @override
  String toString() {
    return 'Sections: $sections totalSections: $totalSections';
  }
}

class Section {
  Section({
    required this.sectionId,
    required this.sectionType,
    required this.questions,
  });

  String sectionId;
  String sectionType;
  List<Answer> questions;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json["sectionId"],
    sectionType: json["sectionType"],
    questions: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sectionId": sectionId,
    "sectionType": sectionType,
    "answers": List<dynamic>.from(questions.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'SectionId: $sectionId, sectionType: $sectionType, answers: $questions';
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
