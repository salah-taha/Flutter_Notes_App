import 'dart:convert';

class Note {
  final String id;
  final String? text;
  final String? userId;
  final DateTime? placeDateTime;
  Note({
    required this.id,
    this.text,
    this.userId,
    this.placeDateTime,
  });

  Note copyWith({
    String? text,
    String? id,
    String? userId,
    DateTime? placeDateTime,
  }) {
    return Note(
      text: text ?? this.text,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      placeDateTime: placeDateTime ?? this.placeDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'text': text,
      'userId': userId,
      'placeDateTime': placeDateTime?.toIso8601String(),
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      text: map['text'] != null ? map['text'] as String : null,
      id: map['id'] != null ? map['id'].toString() : '0',
      userId: map['userId'] != null ? map['userId'] as String : null,
      placeDateTime: map['placeDateTime'] != null
          ? DateTime.tryParse(map['placeDateTime'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Note(text: $text, id: $id, userId: $userId, placeDateTime: $placeDateTime)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.id == id &&
        other.userId == userId &&
        other.placeDateTime == placeDateTime;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        placeDateTime.hashCode;
  }
}
