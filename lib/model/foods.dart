import 'server/mainwindowdata.dart';

List<DishesData> mostPopular = [];
List<DishesData> topFoods = [];
List<DishesData> dishData = [];
List<DishesData> dishDataRestaurant = [];
List<DishesData> userFavorites = [];
List<DishesData> searchData = [];
List<DishesData> foodsAll = [];

DishesData loadFood(String id){
  for (var item in topFoods)
    if (item.id == id)
      return item;
  for (var item in mostPopular)
    if (item.id == id)
      return item;
  for (var item in dishData)
    if (item.id == id)
      return item;
  for (var item in dishDataRestaurant)
    if (item.id == id)
      return item;
  for (var item in userFavorites)
    if (item.id == id)
      return item;
  for (var item in searchData)
    if (item.id == id)
      return item;
  for (var item in foodsAll)
    if (item.id == id)
      return item;

    return null;
}

addFoods(List<DishesData> foods){
  foodsAll = foods;
}