class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String uid;
  final String username;
  final String profilePic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          createdAt == other.createdAt &&
          postId == other.postId &&
          uid == other.uid &&
          username == other.username &&
          profilePic == other.profilePic;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      createdAt.hashCode ^
      postId.hashCode ^
      uid.hashCode ^
      username.hashCode ^
      profilePic.hashCode;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.uid,
    required this.username,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'comment': this.text,
      'createdAt': this.createdAt,
      'postId': this.postId,
      'uid': this.uid,
      'username': this.username,
      'profilePic': this.profilePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['comment'] as String,
      createdAt: map['createdAt'] as DateTime,
      postId: map['postId'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  Comment copyWith({
    String? id,
    String? comment,
    DateTime? createdAt,
    String? postId,
    String? uid,
    String? username,
    String? profilePic,
  }) {
    return Comment(
      id: id ?? this.id,
      text: comment ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  String toString() {
    return 'Model{id: $id, comment: $text, createdAt: $createdAt, postId: $postId, uid: $uid, username: $username, profilePic: $profilePic}';
  }
}
