import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:adhara/adhara.dart';

part 'builtuser.g.dart';

//class BuiltUserBuilder extends Builder<BuiltUser, BuiltUserBuilder>{
//  BuiltUser build(){ return null; }
//  replace(fn){}
//  update(fn){}
//}

abstract class BuiltUser implements Built<BuiltUser, BuiltUserBuilder> {

  @BuiltValueField()
  int get id;

  @nullable
  @AdharaModelField()
  String get fname;

  @nullable
  String get lanme;

  @nullable
  String get email;

  @nullable
  String get phone;


  BuiltUser._();

  factory BuiltUser([updates(BuiltUserBuilder b)]) = _$BuiltUser;

  static Serializer<BuiltUser> get serializer => _$builtUserSerializer;


}
