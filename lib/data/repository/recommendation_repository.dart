class ItemRecommendation {
  String name;
  String imageName;
  String bigImageName;
  String title;

  ItemRecommendation({
    required this.name,
    required this.imageName,
    required this.bigImageName,
    required this.title,
  });
}

class RecommendationRepository {
  static final List<ItemRecommendation> listOfItemRecommendationPlatform = [
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_food.png',
      bigImageName: 'assets/images/recomendations/recomendation_food_big.png',
      name: "Питание",
      title: "Питание",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_water.png',
      bigImageName: 'assets/images/recomendations/recomendation_water_big.png',
      name: "Вода",
      title: "Вода",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_activity.png',
      bigImageName: 'assets/images/recomendations/recomendation_activity_big.png',
      name: "Активность",
      title: "Активность",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_sleep.png',
      bigImageName: 'assets/images/recomendations/recomendation_sleep_big.png',
      name: "Сон",
      title: "Сон",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_antisress.png',
      bigImageName: 'assets/images/recomendations/recomendation_antistress_big.png',
      name: "Антистресс",
      title: "Антистресс",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_recipes.png',
      bigImageName: 'assets/images/recomendations/recomendation_recipe_big.png',
      name: "Рецепты",
      title: "Рецепты",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_correction.png',
      bigImageName: 'assets/images/recomendations/recomendation_correction_big.png',
      name: "Коррекция",
      title: "Коррекция",
    ),
    ItemRecommendation(
      imageName: 'assets/images/recomendations/recomendation_correction.png',
      bigImageName: 'assets/images/recomendations/recomendation_correction_big.png',
      name: "Коррекция",
      title: "Диета",
    ),
  ];

  ItemRecommendation getButtons(String? name) {
    ItemRecommendation? item;
    for (var element in listOfItemRecommendationPlatform) {
      if (element.title == name) {
        item = element;
        break;
      }
    }
    return item ?? listOfItemRecommendationPlatform[0];
  }
}
