
class FavoriteModel {
  final String favoriteId;
  String favoriteName;

  double currentFlow;
  double currentStage;
  bool increasing;
  DateTime lastUpdated;

  Map<String, double> prefStage = {'high': null, 'low': null};
  Map<String, double> prefFlow = {'high': null, 'low': null};

  FavoriteModel(this.favoriteId, [this.favoriteName]);
}