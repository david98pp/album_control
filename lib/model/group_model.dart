class GroupModel {
  late String groupName;
  late Map countries;
  int contGroup = 0;
  GroupModel(this.groupName, this.countries);

  GroupModel.fromJson(Map data) {
    //List<GroupModel> res=[];

    groupName = data['Grupo $contGroup']['name'];
    countries = data['Grupo $contGroup']['countries'];
    //  res.add(GroupModel(groupName,countries));
    contGroup++;

//    return res;
  }
}
