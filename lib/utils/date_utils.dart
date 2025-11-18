import 'package:intl/intl.dart';

class DateUtilsCustom {
  /// Formata DateTime para `dd/MM/yyyy HH:mm`
  static String formatDateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  /// Retorna se data está no passado (comparando até minutos)
  static bool isPast(DateTime dt) {
    final now = DateTime.now();
    return dt.isBefore(now);
  }

  /// Ajusta e retorna DateTime em UTC (útil antes de salvar no Firestore se quiser padronizar)
  static DateTime toUtcSafe(DateTime dt) {
    return dt.toUtc();
  }
}
