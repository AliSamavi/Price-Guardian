// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'databases.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DBStoresAdapter extends TypeAdapter<DBStores> {
  @override
  final int typeId = 0;

  @override
  DBStores read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DBStores(
      storeName: fields[0] as String,
      storeDomain: fields[1] as String,
      storeToken: fields[2] as String,
      storeCurrency: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DBStores obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.storeName)
      ..writeByte(1)
      ..write(obj.storeDomain)
      ..writeByte(2)
      ..write(obj.storeToken)
      ..writeByte(3)
      ..write(obj.storeCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBStoresAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DBSchemasAdapter extends TypeAdapter<DBSchemas> {
  @override
  final int typeId = 1;

  @override
  DBSchemas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DBSchemas(
      name: fields[0] as String,
      priceSelectorA: fields[1] as String,
      priceSelectorB: fields[2] as String?,
      discountSelector: fields[3] as String?,
      currency: fields[4] as String,
      percentage: fields[5] as num?,
      priceBeforeDiscount: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DBSchemas obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.priceSelectorA)
      ..writeByte(2)
      ..write(obj.priceSelectorB)
      ..writeByte(3)
      ..write(obj.discountSelector)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.percentage)
      ..writeByte(6)
      ..write(obj.priceBeforeDiscount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBSchemasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DBProductsAdapter extends TypeAdapter<DBProducts> {
  @override
  final int typeId = 2;

  @override
  DBProducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DBProducts(
      id: fields[0] as int,
      key: fields[1] as int,
      url: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DBProducts obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
