class Mark {
  int id;
  int page_num;
  String surah;
  int type;
  String? created_at;

  Mark(this.id, this.page_num, this.surah, this.type, this.created_at);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'page_num': page_num,
      'surah': surah,
      'type': type,
      'created_at': created_at,
    };
    return map;
  }

  factory Mark.fromJson(dynamic json) {
    return Mark(json['id'], json['page_num'], json['surah'], json['type'],
        json['created_at']);
  }
}
