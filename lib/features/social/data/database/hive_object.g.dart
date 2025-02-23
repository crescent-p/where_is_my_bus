// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePostAdapter extends TypeAdapter<HivePost> {
  @override
  final int typeId = 0;

  @override
  HivePost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePost(
      uuid: fields[0] as String,
      type: fields[1] as String,
      likes: fields[2] as int,
      userEmail: fields[4] as String,
      image: fields[3] as Uint8List,
      description: fields[5] as String,
      datetime: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HivePost obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.likes)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.userEmail)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.datetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveMiniPostAdapter extends TypeAdapter<HiveMiniPost> {
  @override
  final int typeId = 1;

  @override
  HiveMiniPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMiniPost(
      uuid: fields[0] as String,
      type: fields[1] as String,
      userEmail: fields[2] as String,
      description: fields[3] as String,
      image: fields[4] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMiniPost obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMiniPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveCommentAdapter extends TypeAdapter<HiveComment> {
  @override
  final int typeId = 2;

  @override
  HiveComment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveComment(
      postId: fields[0] as String,
      userName: fields[1] as String,
      text: fields[2] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveComment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
