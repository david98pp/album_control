class Sticker {
  int number = 0;
  String text = '';
  String team = '';
  String group = '';
  int repeated = 0;

  Sticker(this.number, this.text, this.team, this.group, this.repeated);

  factory Sticker.copyWith(Sticker m) {
    return Sticker(m.number, m.text, m.team, m.group, m.repeated);
  }
}
