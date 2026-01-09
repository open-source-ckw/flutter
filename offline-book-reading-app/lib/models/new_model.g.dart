// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSectionCollection on Isar {
  IsarCollection<Section> get sections => this.collection();
}

const SectionSchema = CollectionSchema(
  name: r'Section',
  id: 7698308494449530003,
  properties: {
    r'sImage': PropertySchema(
      id: 0,
      name: r'sImage',
      type: IsarType.string,
    ),
    r'sSubTitle': PropertySchema(
      id: 1,
      name: r'sSubTitle',
      type: IsarType.string,
    ),
    r'sTitle': PropertySchema(
      id: 2,
      name: r'sTitle',
      type: IsarType.string,
    )
  },
  estimateSize: _sectionEstimateSize,
  serialize: _sectionSerialize,
  deserialize: _sectionDeserialize,
  deserializeProp: _sectionDeserializeProp,
  idName: r'sId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sectionGetId,
  getLinks: _sectionGetLinks,
  attach: _sectionAttach,
  version: '3.1.0+1',
);

int _sectionEstimateSize(
  Section object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sImage.length * 3;
  bytesCount += 3 + object.sSubTitle.length * 3;
  bytesCount += 3 + object.sTitle.length * 3;
  return bytesCount;
}

void _sectionSerialize(
  Section object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.sImage);
  writer.writeString(offsets[1], object.sSubTitle);
  writer.writeString(offsets[2], object.sTitle);
}

Section _sectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Section();
  object.sId = id;
  object.sImage = reader.readString(offsets[0]);
  object.sSubTitle = reader.readString(offsets[1]);
  object.sTitle = reader.readString(offsets[2]);
  return object;
}

P _sectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sectionGetId(Section object) {
  return object.sId;
}

List<IsarLinkBase<dynamic>> _sectionGetLinks(Section object) {
  return [];
}

void _sectionAttach(IsarCollection<dynamic> col, Id id, Section object) {
  object.sId = id;
}

extension SectionQueryWhereSort on QueryBuilder<Section, Section, QWhere> {
  QueryBuilder<Section, Section, QAfterWhere> anySId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SectionQueryWhere on QueryBuilder<Section, Section, QWhereClause> {
  QueryBuilder<Section, Section, QAfterWhereClause> sIdEqualTo(Id sId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: sId,
        upper: sId,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterWhereClause> sIdNotEqualTo(Id sId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: sId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: sId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: sId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: sId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Section, Section, QAfterWhereClause> sIdGreaterThan(Id sId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: sId, includeLower: include),
      );
    });
  }

  QueryBuilder<Section, Section, QAfterWhereClause> sIdLessThan(Id sId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: sId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Section, Section, QAfterWhereClause> sIdBetween(
    Id lowerSId,
    Id upperSId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerSId,
        includeLower: includeLower,
        upper: upperSId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SectionQueryFilter
    on QueryBuilder<Section, Section, QFilterCondition> {
  QueryBuilder<Section, Section, QAfterFilterCondition> sIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sSubTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sSubTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sSubTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sSubTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sSubTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sSubTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> sTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sTitle',
        value: '',
      ));
    });
  }
}

extension SectionQueryObject
    on QueryBuilder<Section, Section, QFilterCondition> {}

extension SectionQueryLinks
    on QueryBuilder<Section, Section, QFilterCondition> {}

extension SectionQuerySortBy on QueryBuilder<Section, Section, QSortBy> {
  QueryBuilder<Section, Section, QAfterSortBy> sortBySImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sImage', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> sortBySImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sImage', Sort.desc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> sortBySSubTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sSubTitle', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> sortBySSubTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sSubTitle', Sort.desc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> sortBySTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sTitle', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> sortBySTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sTitle', Sort.desc);
    });
  }
}

extension SectionQuerySortThenBy
    on QueryBuilder<Section, Section, QSortThenBy> {
  QueryBuilder<Section, Section, QAfterSortBy> thenBySId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.desc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sImage', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sImage', Sort.desc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySSubTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sSubTitle', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySSubTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sSubTitle', Sort.desc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sTitle', Sort.asc);
    });
  }

  QueryBuilder<Section, Section, QAfterSortBy> thenBySTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sTitle', Sort.desc);
    });
  }
}

extension SectionQueryWhereDistinct
    on QueryBuilder<Section, Section, QDistinct> {
  QueryBuilder<Section, Section, QDistinct> distinctBySImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Section, Section, QDistinct> distinctBySSubTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sSubTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Section, Section, QDistinct> distinctBySTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sTitle', caseSensitive: caseSensitive);
    });
  }
}

extension SectionQueryProperty
    on QueryBuilder<Section, Section, QQueryProperty> {
  QueryBuilder<Section, int, QQueryOperations> sIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sId');
    });
  }

  QueryBuilder<Section, String, QQueryOperations> sImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sImage');
    });
  }

  QueryBuilder<Section, String, QQueryOperations> sSubTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sSubTitle');
    });
  }

  QueryBuilder<Section, String, QQueryOperations> sTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sTitle');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTopicCollection on Isar {
  IsarCollection<Topic> get topics => this.collection();
}

const TopicSchema = CollectionSchema(
  name: r'Topic',
  id: 5334984740663963266,
  properties: {
    r'sId': PropertySchema(
      id: 0,
      name: r'sId',
      type: IsarType.long,
    ),
    r'tName': PropertySchema(
      id: 1,
      name: r'tName',
      type: IsarType.string,
    ),
    r'tTranslateName': PropertySchema(
      id: 2,
      name: r'tTranslateName',
      type: IsarType.string,
    )
  },
  estimateSize: _topicEstimateSize,
  serialize: _topicSerialize,
  deserialize: _topicDeserialize,
  deserializeProp: _topicDeserializeProp,
  idName: r'tId',
  indexes: {
    r'tName_sId': IndexSchema(
      id: 2829770972462745429,
      name: r'tName_sId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tName',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'sId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _topicGetId,
  getLinks: _topicGetLinks,
  attach: _topicAttach,
  version: '3.1.0+1',
);

int _topicEstimateSize(
  Topic object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.tName.length * 3;
  bytesCount += 3 + object.tTranslateName.length * 3;
  return bytesCount;
}

void _topicSerialize(
  Topic object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.sId);
  writer.writeString(offsets[1], object.tName);
  writer.writeString(offsets[2], object.tTranslateName);
}

Topic _topicDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Topic();
  object.sId = reader.readLong(offsets[0]);
  object.tId = id;
  object.tName = reader.readString(offsets[1]);
  object.tTranslateName = reader.readString(offsets[2]);
  return object;
}

P _topicDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _topicGetId(Topic object) {
  return object.tId;
}

List<IsarLinkBase<dynamic>> _topicGetLinks(Topic object) {
  return [];
}

void _topicAttach(IsarCollection<dynamic> col, Id id, Topic object) {
  object.tId = id;
}

extension TopicByIndex on IsarCollection<Topic> {
  Future<Topic?> getByTNameSId(String tName, int sId) {
    return getByIndex(r'tName_sId', [tName, sId]);
  }

  Topic? getByTNameSIdSync(String tName, int sId) {
    return getByIndexSync(r'tName_sId', [tName, sId]);
  }

  Future<bool> deleteByTNameSId(String tName, int sId) {
    return deleteByIndex(r'tName_sId', [tName, sId]);
  }

  bool deleteByTNameSIdSync(String tName, int sId) {
    return deleteByIndexSync(r'tName_sId', [tName, sId]);
  }

  Future<List<Topic?>> getAllByTNameSId(
      List<String> tNameValues, List<int> sIdValues) {
    final len = tNameValues.length;
    assert(
        sIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tNameValues[i], sIdValues[i]]);
    }

    return getAllByIndex(r'tName_sId', values);
  }

  List<Topic?> getAllByTNameSIdSync(
      List<String> tNameValues, List<int> sIdValues) {
    final len = tNameValues.length;
    assert(
        sIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tNameValues[i], sIdValues[i]]);
    }

    return getAllByIndexSync(r'tName_sId', values);
  }

  Future<int> deleteAllByTNameSId(
      List<String> tNameValues, List<int> sIdValues) {
    final len = tNameValues.length;
    assert(
        sIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tNameValues[i], sIdValues[i]]);
    }

    return deleteAllByIndex(r'tName_sId', values);
  }

  int deleteAllByTNameSIdSync(List<String> tNameValues, List<int> sIdValues) {
    final len = tNameValues.length;
    assert(
        sIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tNameValues[i], sIdValues[i]]);
    }

    return deleteAllByIndexSync(r'tName_sId', values);
  }

  Future<Id> putByTNameSId(Topic object) {
    return putByIndex(r'tName_sId', object);
  }

  Id putByTNameSIdSync(Topic object, {bool saveLinks = true}) {
    return putByIndexSync(r'tName_sId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTNameSId(List<Topic> objects) {
    return putAllByIndex(r'tName_sId', objects);
  }

  List<Id> putAllByTNameSIdSync(List<Topic> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'tName_sId', objects, saveLinks: saveLinks);
  }
}

extension TopicQueryWhereSort on QueryBuilder<Topic, Topic, QWhere> {
  QueryBuilder<Topic, Topic, QAfterWhere> anyTId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TopicQueryWhere on QueryBuilder<Topic, Topic, QWhereClause> {
  QueryBuilder<Topic, Topic, QAfterWhereClause> tIdEqualTo(Id tId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: tId,
        upper: tId,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tIdNotEqualTo(Id tId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: tId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: tId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: tId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: tId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tIdGreaterThan(Id tId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: tId, includeLower: include),
      );
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tIdLessThan(Id tId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: tId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tIdBetween(
    Id lowerTId,
    Id upperTId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerTId,
        includeLower: includeLower,
        upper: upperTId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameEqualToAnySId(
      String tName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tName_sId',
        value: [tName],
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameNotEqualToAnySId(
      String tName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [],
              upper: [tName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [],
              upper: [tName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameSIdEqualTo(
      String tName, int sId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tName_sId',
        value: [tName, sId],
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameEqualToSIdNotEqualTo(
      String tName, int sId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName],
              upper: [tName, sId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName, sId],
              includeLower: false,
              upper: [tName],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName, sId],
              includeLower: false,
              upper: [tName],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tName_sId',
              lower: [tName],
              upper: [tName, sId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameEqualToSIdGreaterThan(
    String tName,
    int sId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tName_sId',
        lower: [tName, sId],
        includeLower: include,
        upper: [tName],
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameEqualToSIdLessThan(
    String tName,
    int sId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tName_sId',
        lower: [tName],
        upper: [tName, sId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterWhereClause> tNameEqualToSIdBetween(
    String tName,
    int lowerSId,
    int upperSId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tName_sId',
        lower: [tName, lowerSId],
        includeLower: includeLower,
        upper: [tName, upperSId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TopicQueryFilter on QueryBuilder<Topic, Topic, QFilterCondition> {
  QueryBuilder<Topic, Topic, QAfterFilterCondition> sIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> sIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> sIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> sIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tName',
        value: '',
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tName',
        value: '',
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tTranslateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tTranslateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tTranslateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tTranslateName',
        value: '',
      ));
    });
  }

  QueryBuilder<Topic, Topic, QAfterFilterCondition> tTranslateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tTranslateName',
        value: '',
      ));
    });
  }
}

extension TopicQueryObject on QueryBuilder<Topic, Topic, QFilterCondition> {}

extension TopicQueryLinks on QueryBuilder<Topic, Topic, QFilterCondition> {}

extension TopicQuerySortBy on QueryBuilder<Topic, Topic, QSortBy> {
  QueryBuilder<Topic, Topic, QAfterSortBy> sortBySId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> sortBySIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.desc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> sortByTName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tName', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> sortByTNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tName', Sort.desc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> sortByTTranslateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tTranslateName', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> sortByTTranslateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tTranslateName', Sort.desc);
    });
  }
}

extension TopicQuerySortThenBy on QueryBuilder<Topic, Topic, QSortThenBy> {
  QueryBuilder<Topic, Topic, QAfterSortBy> thenBySId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenBySIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sId', Sort.desc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.desc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tName', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tName', Sort.desc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTTranslateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tTranslateName', Sort.asc);
    });
  }

  QueryBuilder<Topic, Topic, QAfterSortBy> thenByTTranslateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tTranslateName', Sort.desc);
    });
  }
}

extension TopicQueryWhereDistinct on QueryBuilder<Topic, Topic, QDistinct> {
  QueryBuilder<Topic, Topic, QDistinct> distinctBySId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sId');
    });
  }

  QueryBuilder<Topic, Topic, QDistinct> distinctByTName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Topic, Topic, QDistinct> distinctByTTranslateName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tTranslateName',
          caseSensitive: caseSensitive);
    });
  }
}

extension TopicQueryProperty on QueryBuilder<Topic, Topic, QQueryProperty> {
  QueryBuilder<Topic, int, QQueryOperations> tIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tId');
    });
  }

  QueryBuilder<Topic, int, QQueryOperations> sIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sId');
    });
  }

  QueryBuilder<Topic, String, QQueryOperations> tNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tName');
    });
  }

  QueryBuilder<Topic, String, QQueryOperations> tTranslateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tTranslateName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContentCollection on Isar {
  IsarCollection<Content> get contents => this.collection();
}

const ContentSchema = CollectionSchema(
  name: r'Content',
  id: 2749874844035024652,
  properties: {
    r'cAlign': PropertySchema(
      id: 0,
      name: r'cAlign',
      type: IsarType.string,
    ),
    r'cBold': PropertySchema(
      id: 1,
      name: r'cBold',
      type: IsarType.bool,
    ),
    r'cImage': PropertySchema(
      id: 2,
      name: r'cImage',
      type: IsarType.string,
    ),
    r'cText': PropertySchema(
      id: 3,
      name: r'cText',
      type: IsarType.string,
    ),
    r'tId': PropertySchema(
      id: 4,
      name: r'tId',
      type: IsarType.long,
    )
  },
  estimateSize: _contentEstimateSize,
  serialize: _contentSerialize,
  deserialize: _contentDeserialize,
  deserializeProp: _contentDeserializeProp,
  idName: r'cId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _contentGetId,
  getLinks: _contentGetLinks,
  attach: _contentAttach,
  version: '3.1.0+1',
);

int _contentEstimateSize(
  Content object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cAlign.length * 3;
  {
    final value = object.cImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.cText.length * 3;
  return bytesCount;
}

void _contentSerialize(
  Content object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cAlign);
  writer.writeBool(offsets[1], object.cBold);
  writer.writeString(offsets[2], object.cImage);
  writer.writeString(offsets[3], object.cText);
  writer.writeLong(offsets[4], object.tId);
}

Content _contentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Content();
  object.cAlign = reader.readString(offsets[0]);
  object.cBold = reader.readBool(offsets[1]);
  object.cId = id;
  object.cImage = reader.readStringOrNull(offsets[2]);
  object.cText = reader.readString(offsets[3]);
  object.tId = reader.readLong(offsets[4]);
  return object;
}

P _contentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _contentGetId(Content object) {
  return object.cId;
}

List<IsarLinkBase<dynamic>> _contentGetLinks(Content object) {
  return [];
}

void _contentAttach(IsarCollection<dynamic> col, Id id, Content object) {
  object.cId = id;
}

extension ContentQueryWhereSort on QueryBuilder<Content, Content, QWhere> {
  QueryBuilder<Content, Content, QAfterWhere> anyCId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ContentQueryWhere on QueryBuilder<Content, Content, QWhereClause> {
  QueryBuilder<Content, Content, QAfterWhereClause> cIdEqualTo(Id cId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: cId,
        upper: cId,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterWhereClause> cIdNotEqualTo(Id cId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: cId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: cId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: cId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: cId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Content, Content, QAfterWhereClause> cIdGreaterThan(Id cId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: cId, includeLower: include),
      );
    });
  }

  QueryBuilder<Content, Content, QAfterWhereClause> cIdLessThan(Id cId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: cId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Content, Content, QAfterWhereClause> cIdBetween(
    Id lowerCId,
    Id upperCId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerCId,
        includeLower: includeLower,
        upper: upperCId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ContentQueryFilter
    on QueryBuilder<Content, Content, QFilterCondition> {
  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cAlign',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cAlign',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cAlignIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cBoldEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cBold',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cImage',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cImage',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cText',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> cTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cText',
        value: '',
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> tIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> tIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> tIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tId',
        value: value,
      ));
    });
  }

  QueryBuilder<Content, Content, QAfterFilterCondition> tIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ContentQueryObject
    on QueryBuilder<Content, Content, QFilterCondition> {}

extension ContentQueryLinks
    on QueryBuilder<Content, Content, QFilterCondition> {}

extension ContentQuerySortBy on QueryBuilder<Content, Content, QSortBy> {
  QueryBuilder<Content, Content, QAfterSortBy> sortByCAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cAlign', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cAlign', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCBold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cBold', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCBoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cBold', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cImage', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cImage', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cText', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByCTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cText', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByTId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> sortByTIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.desc);
    });
  }
}

extension ContentQuerySortThenBy
    on QueryBuilder<Content, Content, QSortThenBy> {
  QueryBuilder<Content, Content, QAfterSortBy> thenByCAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cAlign', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cAlign', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCBold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cBold', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCBoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cBold', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cId', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cId', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cImage', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cImage', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cText', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByCTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cText', Sort.desc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByTId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.asc);
    });
  }

  QueryBuilder<Content, Content, QAfterSortBy> thenByTIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tId', Sort.desc);
    });
  }
}

extension ContentQueryWhereDistinct
    on QueryBuilder<Content, Content, QDistinct> {
  QueryBuilder<Content, Content, QDistinct> distinctByCAlign(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cAlign', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Content, Content, QDistinct> distinctByCBold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cBold');
    });
  }

  QueryBuilder<Content, Content, QDistinct> distinctByCImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Content, Content, QDistinct> distinctByCText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Content, Content, QDistinct> distinctByTId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tId');
    });
  }
}

extension ContentQueryProperty
    on QueryBuilder<Content, Content, QQueryProperty> {
  QueryBuilder<Content, int, QQueryOperations> cIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cId');
    });
  }

  QueryBuilder<Content, String, QQueryOperations> cAlignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cAlign');
    });
  }

  QueryBuilder<Content, bool, QQueryOperations> cBoldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cBold');
    });
  }

  QueryBuilder<Content, String?, QQueryOperations> cImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cImage');
    });
  }

  QueryBuilder<Content, String, QQueryOperations> cTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cText');
    });
  }

  QueryBuilder<Content, int, QQueryOperations> tIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImageModelCollection on Isar {
  IsarCollection<ImageModel> get imageModels => this.collection();
}

const ImageModelSchema = CollectionSchema(
  name: r'ImageModel',
  id: -4998388787585861710,
  properties: {
    r'imagePath': PropertySchema(
      id: 0,
      name: r'imagePath',
      type: IsarType.string,
    )
  },
  estimateSize: _imageModelEstimateSize,
  serialize: _imageModelSerialize,
  deserialize: _imageModelDeserialize,
  deserializeProp: _imageModelDeserializeProp,
  idName: r'iId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _imageModelGetId,
  getLinks: _imageModelGetLinks,
  attach: _imageModelAttach,
  version: '3.1.0+1',
);

int _imageModelEstimateSize(
  ImageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imagePath.length * 3;
  return bytesCount;
}

void _imageModelSerialize(
  ImageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.imagePath);
}

ImageModel _imageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImageModel();
  object.iId = id;
  object.imagePath = reader.readString(offsets[0]);
  return object;
}

P _imageModelDeserializeProp<P>(
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

Id _imageModelGetId(ImageModel object) {
  return object.iId;
}

List<IsarLinkBase<dynamic>> _imageModelGetLinks(ImageModel object) {
  return [];
}

void _imageModelAttach(IsarCollection<dynamic> col, Id id, ImageModel object) {
  object.iId = id;
}

extension ImageModelQueryWhereSort
    on QueryBuilder<ImageModel, ImageModel, QWhere> {
  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyIId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ImageModelQueryWhere
    on QueryBuilder<ImageModel, ImageModel, QWhereClause> {
  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> iIdEqualTo(Id iId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: iId,
        upper: iId,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> iIdNotEqualTo(
      Id iId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: iId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: iId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: iId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: iId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> iIdGreaterThan(Id iId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: iId, includeLower: include),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> iIdLessThan(Id iId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: iId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> iIdBetween(
    Id lowerIId,
    Id upperIId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIId,
        includeLower: includeLower,
        upper: upperIId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageModelQueryFilter
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {
  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> iIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iId',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> iIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iId',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> iIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iId',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> iIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }
}

extension ImageModelQueryObject
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {}

extension ImageModelQueryLinks
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {}

extension ImageModelQuerySortBy
    on QueryBuilder<ImageModel, ImageModel, QSortBy> {
  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }
}

extension ImageModelQuerySortThenBy
    on QueryBuilder<ImageModel, ImageModel, QSortThenBy> {
  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByIId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iId', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByIIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iId', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }
}

extension ImageModelQueryWhereDistinct
    on QueryBuilder<ImageModel, ImageModel, QDistinct> {
  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }
}

extension ImageModelQueryProperty
    on QueryBuilder<ImageModel, ImageModel, QQueryProperty> {
  QueryBuilder<ImageModel, int, QQueryOperations> iIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iId');
    });
  }

  QueryBuilder<ImageModel, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }
}
