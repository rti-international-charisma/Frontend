
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

  @override
  String toString() {
    return 'HeartAssessment{assessment: $assessment}';
  }
}


class Assessment {
  Assessment({
    this.id,
    this.section,
    this.introduction,
    this.questions,
  });

  String? id;
  String? section;
  String? introduction;
  List<Question?>? questions;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
    id: json["id"],
    section: json["section"],
    introduction: json["introduction"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "section": section,
    "introduction": introduction,
    "questions": List<dynamic>.from(questions!.map((x) => x?.toJson())),
  };

  @override
  String toString() {
    return 'Assessment{id: $id, section: $section, introduction: $introduction, questions: $questions}';
  }
}


class Question {
  Question({
    this.id,
    this.text,
    this.description,
    this.options,
    this.positiveNarrative = true
  });

  String? id;
  String? text;
  String? description;
  List<Option>? options;
  bool positiveNarrative;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    text: json["text"],
    description: json["description"] == null ? null : json["description"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    positiveNarrative: json["positiveNarrative"]
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "description": description == null ? null : description,
    "options": List<dynamic>.from(options!.map((x) => x.toJson())),
    "positiveNarrative": positiveNarrative,
  };

  @override
  String toString() {
    return 'Question{id: $id, text: $text, description: $description, options: $options, positiveNarrative: $positiveNarrative}';
  }
}

class Option {
  Option({
    this.text,
    this.weightage
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

  @override
  String toString() {
    return 'Option{text: $text, weightage: $weightage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          weightage == other.weightage;

  @override
  int get hashCode => text.hashCode ^ weightage.hashCode;
}
