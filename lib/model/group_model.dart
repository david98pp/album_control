import 'package:album_control/model/country_model.dart';

class Group {
  late String groupName;
  late List<Country> countries;

  Group(this.groupName, this.countries);

  factory Group.copyWith(Group m) {
    return Group(m.groupName, m.countries);
  }
}
