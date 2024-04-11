class Validators{
  ///validate password
  var validatePassword = RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{0,}$");     ///RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{3,}$");
  ///validate email
  var validateMail = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  ///validate phone
  //var validatePhone = RegExp(r"^[+#*()\[\]]*([0-9][ ext+-pw#*()\[\]]*){10,45}$");
  var validatePhone = RegExp(r'(0[3|5|7|8|9])+([0-9]{8})\b');
  var validateNumber = RegExp(r"^[\d]*$");

  ///format datetime dd/mm/yyyy
  var validateDateTime = RegExp(r"^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$");
  var validateYYYY = RegExp(r"^\d{4}$");
  var validateDD= RegExp(r"^(0?[1-9]|[12][0-9]|3[01])$");
  var validateMM = RegExp(r"^(0?[1-9]|1[012])$");
  var validateDDMM = RegExp(r"^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])$");
  var validateNumberSpecial = RegExp(r"^[\d/]*$");
  var validateSpecialCharacters = RegExp(r"\/{2,}");
  var validateStructure = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");
  var validateNumberText = RegExp(r"(?=.*[0-9])\w+");

  var validateSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  bool isValidDateTimeInput(String date){
    if (date.isNotEmpty&&validateNumberSpecial.hasMatch(date)){
      return true;
    }
    return false;
  }

  bool isValidateStructure(String value){
    return validateStructure.hasMatch(value);
  }

  bool isValidateNumberText(String value){
    return validateNumberText.hasMatch(value);
  }

  bool isValidNumberOnly(String date){
    if (date.isNotEmpty&&validateNumber.hasMatch(date)){
      return true;
    }
    return false;
  }
  bool isSpecialCharactersOnly(String date){
    if (date.isNotEmpty&&validateSpecialCharacters.hasMatch(date)){
      return true;
    }
    return false;
  }

  bool containsSpecialCharacter(String text) {
    RegExp specialCharacterRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacterRegExp.hasMatch(text);
  }

  bool isValidDDOnly(String date){
    if (date.isNotEmpty&&validateDD.hasMatch(date)){
      return true;
    }
    return false;
  }
  bool isValidDDMMOnly(String date){
    if (date.isNotEmpty&&validateDDMM.hasMatch(date)){
      return true;
    }
    return false;
  }
  bool isValidMMOnly(String date){
    if (date.isNotEmpty&&validateMM.hasMatch(date)){
      return true;
    }
    return false;
  }
  bool isValidYYYYOnly(String date){
    if (date.isNotEmpty&&validateYYYY.hasMatch(date)){
      return true;
    }
    return false;
  }
  bool isValidPassword(String pass){
    if (validatePassword.hasMatch(pass)){
      return true;
    }
    return false;
  }
  bool isValidMail(String mail){
    if (mail.isNotEmpty&&validateMail.hasMatch(mail)){
      return true;
    }
    return false;
  }
  bool isValidTax(String taxCode){
    if (taxCode.isNotEmpty&&taxCode.length>=10&&taxCode.length<=13){
      return true;
    }
    return false;
  }

  bool isValidPass(String passCode){
    if (passCode.isNotEmpty&&passCode.length>=6&&passCode.length<=20){
      return true;
    }
    return false;
  }
  bool isValidPhoneSMS(String phone){
    if (phone.isNotEmpty&&validatePhone.hasMatch(phone)&&phone[0]=="0"){
      return true;
    }
    return false;
  }
  bool isValidPhone(String phone){
    if (phone.isNotEmpty&&validatePhone.hasMatch(phone)){
      return true;
    }
    return false;
  }
  bool isNumber(String number){
    if (number.isNotEmpty&&validateNumber.hasMatch(number)){
      return true;
    }
    return false;
  }

  bool isValidDatetimeDDMMYYYY(String datetime){
    if (datetime.isNotEmpty&&validateDateTime.hasMatch(datetime)){
      return true;
    }
    return false;
  }


  bool isValidYYYY(String datetime){
    if (datetime.isNotEmpty&&validateYYYY.hasMatch(datetime)){
      return true;
    }
    return false;
  }

  static bool isValidHtml(String src) =>
      src.contains('<html>') && src.contains('</html>');
}