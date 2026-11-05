String formatPrice(double value) =>
    value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);

double parseDouble(dynamic value) => double.tryParse('${value ?? ''}') ?? 0;

int parseInt(dynamic value) => parseDouble(value).toInt();
