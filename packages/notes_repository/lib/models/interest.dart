// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Interest {
  final String id;
  final String? interestText;
  Interest({
    required this.id,
    this.interestText,
  });

  Interest copyWith({
    String? id,
    String? interestText,
  }) {
    return Interest(
      id: id ?? this.id,
      interestText: interestText ?? this.interestText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'intrestText': interestText,
    };
  }

  factory Interest.fromMap(Map<String, dynamic> map) {
    return Interest(
      id: map['id'].toString(),
      interestText:
          map['intrestText'] != null ? map['intrestText'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Interest.fromJson(String source) =>
      Interest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Interest(id: $id, interestText: $interestText)';

  @override
  bool operator ==(covariant Interest other) {
    if (identical(this, other)) return true;

    return other.id == id && other.interestText == interestText;
  }

  @override
  int get hashCode => id.hashCode ^ interestText.hashCode;
}
