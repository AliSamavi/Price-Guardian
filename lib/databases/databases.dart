import 'package:hive/hive.dart';

part 'databases.g.dart';

@HiveType(typeId: 0)
class DBStores extends HiveObject {
  @HiveField(0)
  String storeName;
  @HiveField(1)
  String storeDomain;
  @HiveField(2)
  String storeToken;
  @HiveField(3)
  String storeCurrency;

  DBStores({
    required this.storeName,
    required this.storeDomain,
    required this.storeToken,
    required this.storeCurrency,
  });
}

@HiveType(typeId: 1)
class DBSchemas extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String priceSelectorA;
  @HiveField(2)
  String? priceSelectorB;
  @HiveField(3)
  String? discountSelector;
  @HiveField(4)
  String currency;
  @HiveField(5)
  num? percentage;
  @HiveField(6)
  bool priceBeforeDiscount;

  DBSchemas({
    required this.name,
    required this.priceSelectorA,
    required this.priceSelectorB,
    required this.discountSelector,
    required this.currency,
    required this.percentage,
    required this.priceBeforeDiscount,
  });
}

@HiveType(typeId: 2)
class DBProducts {
  @HiveField(0)
  int id;
  @HiveField(1)
  int key;
  @HiveField(2)
  String url;

  DBProducts({
    required this.id,
    required this.key,
    required this.url,
  });
}
