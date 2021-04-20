
import 'dart:convert';

HeartAssessment heartAssessmentFromJson(String str) => HeartAssessment.fromJson(json.decode(str));

String heartAssessmentToJson(HeartAssessment data) => json.encode(data.toJson());

class HeartAssessment {
  HeartAssessment({
    this.assessment,
  });

  List<Assessment>? assessment;

  factory HeartAssessment.fromJson(Map<String, dynamic> json) => HeartAssessment(
    assessment: List<Assessment>.from(json["assessment"].map((x) => Assessment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "assessment": List<dynamic>.from(assessment!.map((x) => x.toJson())),
  };
}


class Assessment {
  Assessment({
    this.section,
    this.introduction,
    this.questions,
  });

  String? section;
  String? introduction;
  List<Question?>? questions;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
    section: json["section"],
    introduction: json["introduction"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "section": section,
    "introduction": introduction,
    "questions": List<dynamic>.from(questions!.map((x) => x?.toJson())),
  };
}


class Question {
  Question({
    this.text,
    this.description,
    this.options,
  });

  String? text;
  String? description;
  List<Option>? options;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    text: json["text"],
    description: json["description"] == null ? null : json["description"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "description": description == null ? null : description,
    "options": List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  Option({
    this.text,
    this.weightage,
  });

  String? text;
  int? weightage;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    text: json["text"],
    weightage: json["weightage"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "weightage": weightage,
  };
}
