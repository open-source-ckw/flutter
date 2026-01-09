class Config {
  late String _key;
  late dynamic _val;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'key': _key, 'value': _val};
    return map;
  }

  Config(this._key, [this._val]);

  Config.withKey(this._key, [this._val]);

  String get key => _key;

  dynamic get value => _val;

  set key(String newTitle) {
    if (newTitle.length <= 255) {
      this._key = newTitle;
    }
  }

  set value(dynamic newDescription) {
    if (newDescription.length <= 255) {
      this._val = newDescription;
    }
  }

  Config.fromMapObject(Map<String, dynamic> map) {
    this._key = map['key'];
    this._val = map['value'];
  }
}
