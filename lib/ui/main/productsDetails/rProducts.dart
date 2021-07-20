
import 'package:shopping/model/foods.dart';
import 'package:shopping/model/server/loadProducts.dart';
import 'package:shopping/model/server/mainwindowdata.dart';

rProductsLoad(DishesData _this, Function redraw){
  List<String> need = [];
  for (var item in _this.rproducts) {
    var product = loadFood(item.rp);
    if (product == null)
      need.add(item.rp);
  }
  if (need.isNotEmpty)
    loadProducts(need, (List<DishesData> data) {
      print(data);
      foodsAll.addAll(data);
      redraw();
    }, (String _){});
}

