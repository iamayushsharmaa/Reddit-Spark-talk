class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;

  Post({
    required this.id,
    required this.title,
    required this.link,
    required this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          link == other.link &&
          description == other.description &&
          communityName == other.communityName &&
          communityProfilePic == other.communityProfilePic &&
          upvotes == other.upvotes &&
          downvotes == other.downvotes &&
          commentCount == other.commentCount &&
          username == other.username &&
          uid == other.uid &&
          type == other.type &&
          createdAt == other.createdAt &&
          awards == other.awards;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      link.hashCode ^
      description.hashCode ^
      communityName.hashCode ^
      communityProfilePic.hashCode ^
      upvotes.hashCode ^
      downvotes.hashCode ^
      commentCount.hashCode ^
      username.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      awards.hashCode;
  final DateTime createdAt;
  final List<String> awards;


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'link': this.link,
      'description': this.description,
      'communityName': this.communityName,
      'communityProfilePic': this.communityProfilePic,
      'upvotes': this.upvotes,
      'downvotes': this.downvotes,
      'commentCount': this.commentCount,
      'username': this.username,
      'uid': this.uid,
      'type': this.type,
      'createdAt': this.createdAt,
      'awards': this.awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] as String,
      description: map['description'] as String,
      communityName: map['communityName'] as String,
      communityProfilePic: map['communityProfilePic'] as String,
      upvotes: map['upvotes'] as List<String>,
      downvotes: map['downvotes'] as List<String>,
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: map['createdAt'] as DateTime,
      awards: map['awards'] as List<String>,
    );
  }

  @override
  String toString() {
    return 'PostModel{id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards}';
  }

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }
}
