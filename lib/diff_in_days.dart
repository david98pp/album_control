String diffInDays() {
  var dateOfWorldCup = DateTime(2022, 11, 20);
  var currentDate = DateTime.now();
  var different = currentDate.difference(dateOfWorldCup).inDays;
  if (different <= 0) {
    int absValue = different.abs();
    if (absValue >= 2) {
      return 'Faltan ${absValue.toString()} días para el mundial';
    } else if (absValue == 1) {
      return 'Mañana es el incio de la Copa del Mundo';
    } else if (absValue == 0) {
      return 'Hoy incio de la Copa del Mundo';
    }
  }
  return '';
}
