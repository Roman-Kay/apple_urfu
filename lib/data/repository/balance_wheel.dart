
import 'package:flutter/material.dart';

class CategoryItem{
  CategoryItem({
    required this.title,
    required this.image,
    required this.color,
    required this.value
  });

  String title;
  String image;
  Color color;
  int value;
}

class BalanceWheelClass{
  List<CategoryItem> categoryList = [
    CategoryItem(title: "карьера", image: "assets/images/balance_wheel/carier.svg", color: Color(0xFFBE3455), value: 0),
    CategoryItem(title: "здоровье", image: "assets/images/balance_wheel/health.svg", color: Color(0xFF00817D), value: 0),
    CategoryItem(title: "друзья", image: "assets/images/balance_wheel/friends.svg", color: Color(0xFFFF9F00), value: 0),
    CategoryItem(title: "семья", image: "assets/images/balance_wheel/family.svg", color: Color(0xFF15ABEE), value: 0),
    CategoryItem(title: "отдых", image: "assets/images/balance_wheel/rest.svg", color: Color(0xFF688602), value: 0),
    CategoryItem(title: "саморазвитие", image: "assets/images/balance_wheel/education.svg", color: Color(0xFF5AA8A5), value: 0),
    CategoryItem(title: "деньги", image: "assets/images/balance_wheel/money.svg", color: Color(0xFFAA589B), value: 0),
    CategoryItem(title: "хобби", image: "assets/images/balance_wheel/hobbie.svg", color: Color(0xFFC5763B), value: 0),
  ];
}