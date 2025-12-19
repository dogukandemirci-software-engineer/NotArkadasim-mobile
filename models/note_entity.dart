import 'meta.dart';

class NoteResponse {
  final Meta meta;
  final List<NoteEntity> entities;
  final PageInfo pageInfo;

  NoteResponse({
    required this.meta,
    required this.entities,
    required this.pageInfo,
  });

  factory NoteResponse.fromJson(Map<String, dynamic> json) {
    return NoteResponse(
      meta: Meta.fromJson(json['meta']),
      entities: (json['entities'] as List)
          .map((e) => NoteEntity.fromJson(e))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo']),
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'entities': entities.map((e) => e.toJson()).toList(),
    'pageInfo': pageInfo.toJson(),
  };
}

class NoteEntity {
  final String id;
  final String coverImageUrl;
  final String title;
  final String shortDescription;
  final bool isPopular;
  final num rating; // double veya int gelebileceği için num daha güvenlidir
  final int downloadCount;
  final int commentCount;
  final int viewCount;
  final DateTime createdDate;
  final CreatorAppUser creatorAppUser;

  NoteEntity({
    required this.id,
    required this.coverImageUrl,
    required this.title,
    required this.shortDescription,
    required this.isPopular,
    required this.rating,
    required this.downloadCount,
    required this.commentCount,
    required this.viewCount,
    required this.createdDate,
    required this.creatorAppUser,
  });

  factory NoteEntity.fromJson(Map<String, dynamic> json) {
    return NoteEntity(
      id: json['id'],
      coverImageUrl: json['coverImageUrl'],
      title: json['title'],
      shortDescription: json['shortDescription'],
      isPopular: json['isPopular'] ?? false,
      rating: json['rating'] ?? 0,
      downloadCount: json['downloadCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      createdDate: DateTime.parse(json['createdDate']),
      creatorAppUser: CreatorAppUser.fromJson(json['creatorAppUser']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coverImageUrl': coverImageUrl,
    'title': title,
    'shortDescription': shortDescription,
    'isPopular': isPopular,
    'rating': rating,
    'downloadCount': downloadCount,
    'commentCount': commentCount,
    'viewCount': viewCount,
    'createdDate': createdDate.toIso8601String(),
    'creatorAppUser': creatorAppUser.toJson(),
  };
}

class CreatorAppUser {
  final String id;
  final String fullName;
  final String firstName;
  final String lastName;
  final String userName;
  final String profileImageUrl;

  CreatorAppUser({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.profileImageUrl,
  });

  factory CreatorAppUser.fromJson(Map<String, dynamic> json) {
    return CreatorAppUser(
      id: json['id'],
      fullName: json['fullName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'profileImageUrl': profileImageUrl,
  };
}

class PageInfo {
  final int pageNumber;
  final int pageSize;
  final int totalRowCount;
  final int totalPageCount;
  final int skip;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PageInfo({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRowCount,
    required this.totalPageCount,
    required this.skip,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalRowCount: json['totalRowCount'] ?? 0,
      totalPageCount: json['totalPageCount'] ?? 0,
      skip: json['skip'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'totalRowCount': totalRowCount,
    'totalPageCount': totalPageCount,
    'skip': skip,
    'hasNextPage': hasNextPage,
    'hasPreviousPage': hasPreviousPage,
  };
}