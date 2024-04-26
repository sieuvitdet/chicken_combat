import 'dart:math';

import 'package:intl/intl.dart';

class StringUtils {
  static String generateRandomName() {
    List<String> availableNames = [
      'Táo', 'Mít', 'Bưởi', 'Sapo', 'Dứa', 'Bơ', 'Dừa', 'Bòn Bon', 'Ổi', 'Khoai',
      'Cà rốt', 'Ớt', 'Bí Ngô', 'Cà Phê', 'Thóc', 'Ngô', 'Bắp', 'Đậu Đậu', 'Nếp',
      'Gạo', 'Coca', 'Pepsi', 'Cheese', 'Tiger', 'Ken', 'Jerry', 'Tom', 'Kid',
      'Anthony', 'Henry', 'Bernard', 'Tintin', 'Bean', 'Leonard', 'Leo', 'Lion',
      'Golf', 'Gold', 'Jung', 'Akio', 'Gà', 'Gấu'
    ];
    final random = Random();
    final randomName = availableNames[random.nextInt(availableNames.length)];
    final randomNumber = random.nextInt(1000).toString().padLeft(3, '0');
    final fullName = '$randomName$randomNumber';
    return fullName;
  }

  static String generateRandomTeam() {
    List<String> availableNames = [
      'Táo', 'Mít', 'Bưởi', 'Sapo', 'Dứa', 'Bơ', 'Dừa', 'Bòn Bon', 'Ổi', 'Khoai',
      'Cà rốt', 'Ớt', 'Bí Ngô', 'Cà Phê', 'Thóc', 'Ngô', 'Bắp', 'Đậu Đậu', 'Nếp',
      'Gạo', 'Coca', 'Pepsi', 'Cheese', 'Tiger', 'Ken', 'Jerry', 'Tom', 'Kid',
      'Anthony', 'Henry', 'Bernard', 'Tintin', 'Bean', 'Leonard', 'Leo', 'Lion',
      'Golf', 'Gold', 'Jung', 'Akio', 'Gà', 'Gấu'
    ];
    final random = Random();
    final randomName = availableNames[random.nextInt(availableNames.length)];
    final fullName = '$randomName Team';
    return fullName;
  }

  static String convertToLowerCase(String input) {
    return input.toLowerCase();
  }

  static List<String> convertDynamicListToStringList(List<dynamic> dynamicList) {
    return dynamicList.map((element) => element.toString()).toList();
  }

  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}