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
  });

  final String? id;
  final String? category;
  final String? code;
  final String? name;

  factory TableType.fromJson(Map<String,dynamic> json) => TableType(
    id: json['id']?.toString(),
    category: json['category']?.toString(),
    code: json['code']?.toString(),
    name: json['name']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'code': code,
    'name': name
  };

  TableType clone() => TableType(
    id: id,
    category: category,
    code: code,
    name: name
  );


  TableType copyWith({
    Optional<String?>? id,
    Optional<String?>? category,
    Optional<String?>? code,
    Optional<String?>? name
  }) => TableType(
    id: checkOptional(id, () => this.id),
    category: checkOptional(category, () => this.category),
    code: checkOptional(code, () => this.code),
    name: checkOptional(name, () => this.name),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is TableType && id == other.id && category == other.category && code == other.code && name == other.name;

  @override
  int get hashCode => id.hashCode ^ category.hashCode ^ code.hashCode ^ name.hashCode;
}
