class Task {
  String _title;
  int _time;
  int _id;
  int _date;
  String _category;
  String _toggle;

  Task(this._title, this._time,this._id, this._date, this._category,
      this._toggle);

  Task.map(dynamic obj) {
    this._title = obj['title'];
    this._time = obj['time'];
    this._id = obj['id'];
    this._date = obj['date'];
    this._category = obj['category'];
    this._toggle = obj['toggle'];
  }

  String get title => _title;

  int get time => _time;

  int get date => _date;

  int get id => _id;

  String get category => _category;

  String get toggle => _toggle;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = _title;
    map["time"] = _time;
    map["date"] = _date;
    map["category"] = _category;
    map["toggle"] = _toggle;

    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this._title = map["title"];
    this._time = map["time"];
    this._date = map["date"];
    this._category = map["category"];
    this._toggle = map["toggle"];
    this._id = map["id"];
  }
}
