import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class TableType {

  const TableType({
    this.id,
    this.category,
    this.code,
    this.name,
    this.description,
  });

  final String? id;
  final String? category;
  final String? code;
  final String? name;
  final String? description;

  factory TableType.fromJson(Map<String,dynamic> json) => TableType(
    id: json['id']?.toString(),
    category: json['category']?.toString(),
    code: json['code']?.toString(),
    name: json['name']?.toString(),
    description: json['description']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'code': code,
    'name': name,
    'description': description
  };

  TableType clone() => TableType(
    id: id,
    category: category,
    code: code,
    name: name,
    description: description
  );


  TableType copyWith({
    Optional<String?>? id,
    Optional<String?>? category,
    Optional<String?>? code,
    Optional<String?>? name,
    Optional<String?>? description
  }) => TableType(
    id: checkOptional(id, () => this.id),
    category: checkOptional(category, () => this.category),
    code: checkOptional(code, () => this.code),
    name: checkOptional(name, () => this.name),
    description: checkOptional(description, () => this.description),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is TableType && id == other.id && category == other.category && code == other.code && name == other.name && description == other.description;

  @override
  int get hashCode => id.hashCode ^ category.hashCode ^ code.hashCode ^ name.hashCode ^ description.hashCode;
}
