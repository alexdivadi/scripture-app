// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripturelist.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetScriptureListCollection on Isar {
  IsarCollection<ScriptureList> get scriptureLists => this.collection();
}

const ScriptureListSchema = CollectionSchema(
  name: r'ScriptureList',
  id: -6119356797069755931,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _scriptureListEstimateSize,
  serialize: _scriptureListSerialize,
  deserialize: _scriptureListDeserialize,
  deserializeProp: _scriptureListDeserializeProp,
  idName: r'scriptureListId',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'scriptures': LinkSchema(
      id: 7076905162356785703,
      name: r'scriptures',
      target: r'Scripture',
      single: false,
      linkName: r'collection',
    )
  },
  embeddedSchemas: {},
  getId: _scriptureListGetId,
  getLinks: _scriptureListGetLinks,
  attach: _scriptureListAttach,
  version: '3.0.5',
);

int _scriptureListEstimateSize(
  ScriptureList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _scriptureListSerialize(
  ScriptureList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
}

ScriptureList _scriptureListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScriptureList();
  object.name = reader.readString(offsets[0]);
  object.scriptureListId = id;
  return object;
}

P _scriptureListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scriptureListGetId(ScriptureList object) {
  return object.scriptureListId;
}

List<IsarLinkBase<dynamic>> _scriptureListGetLinks(ScriptureList object) {
  return [object.scriptures];
}

void _scriptureListAttach(
    IsarCollection<dynamic> col, Id id, ScriptureList object) {
  object.scriptureListId = id;
  object.scriptures
      .attach(col, col.isar.collection<Scripture>(), r'scriptures', id);
}

extension ScriptureListByIndex on IsarCollection<ScriptureList> {
  Future<ScriptureList?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  ScriptureList? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<ScriptureList?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<ScriptureList?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(ScriptureList object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(ScriptureList object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<ScriptureList> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<ScriptureList> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension ScriptureListQueryWhereSort
    on QueryBuilder<ScriptureList, ScriptureList, QWhere> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterWhere> anyScriptureListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScriptureListQueryWhere
    on QueryBuilder<ScriptureList, ScriptureList, QWhereClause> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause>
      scriptureListIdEqualTo(Id scriptureListId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: scriptureListId,
        upper: scriptureListId,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause>
      scriptureListIdNotEqualTo(Id scriptureListId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(
                  upper: scriptureListId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(
                  lower: scriptureListId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(
                  lower: scriptureListId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(
                  upper: scriptureListId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause>
      scriptureListIdGreaterThan(Id scriptureListId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(
            lower: scriptureListId, includeLower: include),
      );
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause>
      scriptureListIdLessThan(Id scriptureListId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: scriptureListId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause>
      scriptureListIdBetween(
    Id lowerScriptureListId,
    Id upperScriptureListId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerScriptureListId,
        includeLower: includeLower,
        upper: upperScriptureListId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ScriptureListQueryFilter
    on QueryBuilder<ScriptureList, ScriptureList, QFilterCondition> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scriptureListIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scriptureListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scriptureListIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scriptureListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scriptureListIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scriptureListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scriptureListIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scriptureListId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScriptureListQueryObject
    on QueryBuilder<ScriptureList, ScriptureList, QFilterCondition> {}

extension ScriptureListQueryLinks
    on QueryBuilder<ScriptureList, ScriptureList, QFilterCondition> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition> scriptures(
      FilterQuery<Scripture> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'scriptures');
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'scriptures', length, true, length, true);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'scriptures', 0, true, 0, true);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'scriptures', 0, false, 999999, true);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'scriptures', 0, true, length, include);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'scriptures', length, include, 999999, true);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterFilterCondition>
      scripturesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'scriptures', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ScriptureListQuerySortBy
    on QueryBuilder<ScriptureList, ScriptureList, QSortBy> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ScriptureListQuerySortThenBy
    on QueryBuilder<ScriptureList, ScriptureList, QSortThenBy> {
  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy>
      thenByScriptureListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptureListId', Sort.asc);
    });
  }

  QueryBuilder<ScriptureList, ScriptureList, QAfterSortBy>
      thenByScriptureListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptureListId', Sort.desc);
    });
  }
}

extension ScriptureListQueryWhereDistinct
    on QueryBuilder<ScriptureList, ScriptureList, QDistinct> {
  QueryBuilder<ScriptureList, ScriptureList, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension ScriptureListQueryProperty
    on QueryBuilder<ScriptureList, ScriptureList, QQueryProperty> {
  QueryBuilder<ScriptureList, int, QQueryOperations> scriptureListIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scriptureListId');
    });
  }

  QueryBuilder<ScriptureList, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
