import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskFormatting {
  static final dateMask = MaskTextInputFormatter(mask: '##.##.####');
  static final timeMask = MaskTextInputFormatter(mask: "##:##");
  static final doubleMask = MaskTextInputFormatter(mask: "#.##");
  static final twoDoubleMask = MaskTextInputFormatter(mask: "##.#");

  // 345
  static final threeDigitCodeMask = MaskTextInputFormatter(mask: '###');

  // 3456
  static final fourDigitCodeMask = MaskTextInputFormatter(mask: '####');

  // 345678
  static final sixDigitCodeMask = MaskTextInputFormatter(mask: '######');

  static final phoneMask = MaskTextInputFormatter(
      mask: '(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  // Маска для номера чтобы в начале была 9
  static final phoneMaskWith9 =
  MaskTextInputFormatter(mask: '(9##) ###-##-##', filter: {
    "#": RegExp(r'[0-9]'), // Принимать ввод любой цифры
    "9": RegExp(r'9') // Принимать только ввод цифры 9
  });
}

class RegExpFormatting {
  // кириллица, для проверки
  static final cyrilicalStringRegExp = RegExp(r'[а-яА-ЯЁё]');

  // только строки
  static final stringRegExp = RegExp(r'^[А-Яа-яёЁ]+$');

  // строки и символы
  static final stringAndSymbolsRegExp =
  RegExp(r'''^[А-Яа-яёЁ_&+:;=?@#|'’"<>.,^*()%!-]+$''');

  // дата => 12.03.2023
  static final dateRegExp =
  RegExp(r'((0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.]\d\d\d\d)');

  // время => 12:35
  static final timeRegExp = RegExp(r'^(?:[01][0-9]|2[0-3]):[0-5][0-9]$');

  // целые числа => 3
  static final integerRegExp = RegExp(r'^[0-9]*$');
  

  // 4.56  => по дефолту две цифры после точки
  static final doubleRegExp = RegExp(r'^\d+\.?\d{0,2}');

  // 4.567
  static final doubleWithThreeDigitsRegExp = RegExp(r'^\d+\.?\d{0,3}');

  // 4,56 => по дефолту две цифры после запятой
  static final doubleWithCommaRegExp = RegExp(r'^\d+\,?\d{0,2}');

  // если 4.0 то ноль после точки убирает, при 4.5 так и оставляет
  static final checkDoubleRegExp = RegExp(r'([.]*0)(?!.*\d)');
}
