import 'package:email_validator/email_validator.dart';

class ValidationService{

  static String? emailValidator(String? email){
    if(email!.isEmpty){
      return "Enter email";
    }
    else if(!EmailValidator.validate(email!)){
      return "email id is invalid!";
    }
    return null;
  }

  static String? nameValidator(String? name){

    if(name!.length<2 ){
      return "Name should be minimum 2 characters long";
    }
    return null;
  }

  static String? addressValidator(String? address){

    if(address!.length<20 ){
      return "address should be minimum 20 characters long";
    }
    return null;
  }

  static String? ageValidator(String? age){

    if(age!.isEmpty)
      {
        return "Enter Age";
      }
    else if(age == "0" ){
      return "Invalid age";
    }
    return null;
  }

  static String? dateValidator(String? date){
    if(date!.isEmpty){
      return "Enter Birth Date";
    }
    return null;
  }

}