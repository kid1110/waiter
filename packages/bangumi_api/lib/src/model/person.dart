//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:bangumi_api/src/model/person_images.dart';
import 'package:bangumi_api/src/model/person_type.dart';
import 'package:bangumi_api/src/model/person_career.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'person.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Person {
  /// Returns a new [Person] instance.
  Person({
    required this.id,
    required this.name,
    required this.type,
    required this.career,
    this.images,
    required this.shortSummary,
    required this.locked,
  });

  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final int id;

  @JsonKey(
    name: r'name',
    required: true,
    includeIfNull: false,
  )
  final String name;

  /// `1`, `2`, `3` 表示 `个人`, `公司`, `组合`
  @JsonKey(
    name: r'type',
    required: true,
    includeIfNull: false,
  )
  final PersonType type;

  @JsonKey(
    name: r'career',
    required: true,
    includeIfNull: false,
  )
  final List<PersonCareer> career;

  /// object with some size of images, this object maybe `null`
  @JsonKey(
    name: r'images',
    required: false,
    includeIfNull: false,
  )
  final PersonImages? images;

  @JsonKey(
    name: r'short_summary',
    required: true,
    includeIfNull: false,
  )
  final String shortSummary;

  @JsonKey(
    name: r'locked',
    required: true,
    includeIfNull: false,
  )
  final bool locked;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Person &&
            runtimeType == other.runtimeType &&
            equals([
              id,
              name,
              type,
              career,
              images,
              shortSummary,
              locked,
            ], [
              other.id,
              other.name,
              other.type,
              other.career,
              other.images,
              other.shortSummary,
              other.locked,
            ]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode(
        [
          id,
          name,
          type,
          career,
          images,
          shortSummary,
          locked,
        ],
      );

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
