import '../enums/validation_field_types.dart';

const validationRules = {
  FieldType.email: {
    "characterLength": 50,
    "regex": r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    "security": true,
    "minLenght": 1,
    "generalError": "Geçerli bir email adresi giriniz",
    "lenghtError": "Email uzunluğu 50 karakterden fazla olamaz",
  },
  FieldType.name: {
    "characterLength": 30,
    "regex": r'^[a-zA-Z]+$',
    "security": false,
    "minLenght": 1,
    "generalError": "Geçerli bir isim giriniz",
    "lenghtError": "İsim uzunluğu 30 karakterden fazla olamaz",
  },
  FieldType.surname: {
    "characterLength": 30,
    "regex": r'^[a-zA-Z]+$',
    "security": false,
    "minLenght": 1,
    "generalError": "Geçerli bir soyisim giriniz",
    "lenghtError": "Soyisim 30 karakterden fazla olamaz",
  },
  FieldType.username: {
    "characterLength": 20,
    "regex": r'^[a-zA-Z0-9_]+$',
    "security": false,
    "minLenght": 1,
    "generalError": "Geçerli bir kullanıcı adı giriniz",
    "lenghtError": "Kullanıcı adı uzunluğu 20 karakterden fazla olamaz",
  },
  FieldType.password: {
    "characterLength": 50,
    "regex": r'^(?=.*[A-Z])(?=.*\d).{8,}$',
    "security": true,
    "minLenght": 1,
    "generalError": "Geçerli bir şifre giriniz",
    "lenghtError": "Şifre uzunluğu 50 karakterden fazla olamaz",
  },
};
