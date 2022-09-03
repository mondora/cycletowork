class Survey {
  String id;
  String name;
  String title;
  List<Question> listQuestion;
  bool required;
  bool selected = false;

  Survey({
    required this.id,
    required this.name,
    required this.title,
    required this.listQuestion,
    required this.required,
  });

  factory Survey.fromSurvey(Survey survey) => Survey.fromMap(survey.toJson());

  Survey.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        title = map['title'],
        listQuestion = map['listQuestion']
            .map<Question>(
                (json) => Question.fromMap(Map<String, dynamic>.from(json)))
            .toList(),
        required = map['required'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'listQuestion': listQuestion.map((e) => e.toJson()).toList(),
        'required': required,
      };
}

enum QuestionType {
  text,
  number,
  email,
  multi,
  multiOther,
  selection,
  radio,
  radioOther,
}

class Question {
  String id;
  String tag;
  String title;
  QuestionType type;
  List<String>? answers;
  bool required;
  int maxAnswer;

  Question({
    required this.id,
    required this.tag,
    required this.title,
    required this.type,
    this.answers,
    required this.required,
    required this.maxAnswer,
  });

  Question.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        tag = map['tag'],
        title = map['title'],
        type = map['type'] != null
            ? QuestionType.values.firstWhere(
                (element) =>
                    element.name.toLowerCase() == map['type'].toLowerCase(),
              )
            : QuestionType.text,
        answers =
            map['answers'] != null ? List<String>.from(map['answers']) : null,
        required = map['required'],
        maxAnswer = map['maxAnswer'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'tag': tag,
        'title': title,
        'type': type.name,
        'answers': answers,
        'required': required,
        'maxAnswer': maxAnswer,
      };
}

class SurveyResponse {
  String id;
  String name;
  List<Answer> listAnswer;
  bool selected = false;

  SurveyResponse({
    required this.id,
    required this.name,
    required this.listAnswer,
  });

  SurveyResponse.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        listAnswer = map['listAnswer']
            .map<Answer>(
                (json) => Answer.fromMap(Map<String, dynamic>.from(json)))
            .toList();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
    };
    for (var answer in listAnswer) {
      map.addAll({
        answer.tag: answer.answers,
      });

      if (answer.moreAnswer.isNotEmpty) {
        map.addAll({
          '${answer.tag}_otherAnswer': answer.moreAnswer,
        });
      }
    }

    return map;
  }
}

class Answer {
  String tag;
  String title;
  List<String> answers;
  String moreAnswer;

  Answer({
    required this.tag,
    required this.title,
    required this.answers,
    required this.moreAnswer,
  });

  Answer.fromMap(Map<String, dynamic> map)
      : tag = map['tag'],
        title = map['title'],
        answers = List<String>.from(map['answers']),
        moreAnswer = map['moreAnswer'];

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'title': title,
        'answers': answers,
        'moreAnswer': moreAnswer,
      };
}
