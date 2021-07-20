class ContactModel {
  String numb;
  ContactModel(String numb) {
    this.numb = numb;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'number': numb};
    return map;
  }

  ContactModel.fromMap(Map<String, dynamic> map) {
    //this.number = map['number'];
    numb = map['number'];
  }
}
