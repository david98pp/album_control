String diffInDays() {
  var dateOfWorldCup = DateTime(2022, 11, 20);
  var currentDate = DateTime.now();
  var different = currentDate.difference(dateOfWorldCup).inDays;
  if (different <= 0) {
    int absValue = different.abs() + 1;
    if (absValue >= 2) {
      return 'Faltan solo ${absValue.toString()} días para el mundial';
    } else if (absValue == 1) {
      absValue = currentDate.difference(dateOfWorldCup).inHours;
      if (absValue < 0) {
        return '¡Mañana es el incio de la Copa del Mundo!';
      } else {
        return '¡Hoy es el incio de la Copa del Mundo!';
      }
    }
  }
  return '';
}
