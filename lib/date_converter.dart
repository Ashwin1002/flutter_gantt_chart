import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:intl/intl.dart';

class EasyDateConverter {
  static formatDate({required String date}) {
    return date.toString().substring(0, 10);
  }

  static nepaliDateToEnglishDate({required String date}) {
    int year = int.parse(date.substring(0, 4).toString());
    int month = int.parse(date.substring(5, 7).toString());
    int day = int.parse(date.substring(8, 10).toString());
    DateTime finalDate = NepaliDateTime(year, month, day, 0, 0, 0).toDateTime();
    return finalDate.toString();
  }

  static englishDateToNepaliDate({required String date}) {
    int year = int.parse(date.substring(0, 4).toString());
    int month = int.parse(date.substring(5, 7).toString());
    int day = int.parse(date.substring(8, 10).toString());
    NepaliDateTime finalDate =
        DateTime(year, month, day, 0, 0, 0).toNepaliDateTime();
    return finalDate.toString();
  }

  ///
  ///Converting Date format to Month Day, Year e.g.(Aug 8, 2022)
  static engDateFormatToMonthDay({required String date}) {
    DateTime convDate = DateTime.parse(date);
    DateFormat formatedDate = DateFormat('MMMM dd, y');
    String finalDate = formatedDate.format(convDate);
    return finalDate;
  }

  ///Converting Date format to Month Day, Year e.g.(Aug 8, 2022)
  static engDateFormatToHalfMonthDay({required String date}) {
    DateTime convDate = DateTime.parse(date);
    DateFormat formatedDate = DateFormat('MMM dd, y');
    String finalDate = formatedDate.format(convDate);
    return finalDate;
  }

  static nepaliDateFormatToMonthDay({required String date}) {
    NepaliDateTime convDate = NepaliDateTime.parse(date.replaceAll("/", "-"));
    // NepaliDateFormat formatedDate = NepaliDateFormat.yMMMMd();
    NepaliDateFormat formatedDate = NepaliDateFormat('dd MMMM, yyyy');
    String finalDate = formatedDate.format(convDate);
    return finalDate;
  }

  static nepaliDateFormatToHalfMonthDay({required String date}) {
    NepaliDateTime convDate = NepaliDateTime.parse(date.replaceAll("/", "-"));
    // NepaliDateFormat formatedDate = NepaliDateFormat.yMMMMd();
    NepaliDateFormat formatedDate = NepaliDateFormat('dd MMM, yyyy');
    String finalDate = formatedDate.format(convDate);
    return finalDate;
  }

  static String getMonthID(String month) {
    switch (month) {
      case "Baishak":
        return "01";
      case "Jestha":
        return "02";
      case "Ashad":
        return "03";
      case "Shrawan":
        return "04";
      case "Bhadra":
        return "05";
      case "Aswin":
        return "06";
      case "Kartik":
        return "07";
      case "Mangsir":
        return "08";
      case "Poush":
        return "09";
      case "Magh":
        return "10";
      case "Falgun":
        return "11";
      case "Chaitra":
        return "12";
    }
    return "";
  }

  static String getNepaliMonthNameFromId(String month) {
    switch (month) {
      case "01":
        return "Baishak";
      case "1":
        return "Baishak";
      case "02":
        return "Jestha";
      case "2":
        return "Jestha";
      case "03":
        return "Ashad";
      case "3":
        return "Ashad";
      case "04":
        return "Shrawan";
      case "4":
        return "Shrawan";
      case "05":
        return "Bhadra";
      case "5":
        return "Bhadra";
      case "06":
        return "Aswin";
      case "6":
        return "Aswin";
      case "07":
        return "Kartik";
      case "7":
        return "Kartik";
      case "08":
        return "Mangsir";
      case "8":
        return "Mangsir";
      case "09":
        return "Poush";
      case "9":
        return "Poush";
      case "10":
        return "Magh";
      case "11":
        return "Falgun";
      case "12":
        return "Chaitra";
    }
    return "";
  }

  static String getEnglishFullMonthName(String month) {
    switch (month) {
      case "01":
        return "January";
      case "1":
        return "January";
      case "02":
        return "February";
      case "2":
        return "February";
      case "03":
        return "March";
      case "3":
        return "March";
      case "04":
        return "April";
      case "4":
        return "April";
      case "05":
        return "May";
      case "5":
        return "May";
      case "06":
        return "June";
      case "6":
        return "June";
      case "07":
        return "July";
      case "7":
        return "July";
      case "08":
        return "August";
      case "8":
        return "August";
      case "09":
        return "September";
      case "9":
        return "September";
      case "10":
        return "October";
      case "11":
        return "November";
      case "12":
        return "December";
      case "13":
        return "January";
    }
    return "";
  }

  static String getEnglishHalfMonthName(String month) {
    switch (month) {
      case "01":
        return "Jan";
      case "1":
        return "Jan";
      case "02":
        return "Feb";
      case "2":
        return "Feb";
      case "03":
        return "Mar";
      case "3":
        return "Mar";
      case "04":
        return "Apr";
      case "4":
        return "Apr";
      case "05":
        return "May";
      case "5":
        return "May";
      case "06":
        return "Jun";
      case "6":
        return "Jun";
      case "07":
        return "Jul";
      case "7":
        return "Jul";
      case "08":
        return "Aug";
      case "8":
        return "Aug";
      case "09":
        return "Sept";
      case "9":
        return "Sept";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      case "12":
        return "Dec";
      case "13":
        return "Jan";
    }
    return "";
  }

  static List<String> getNepaliMonth() {
    List<String> eMonth = [];
    eMonth.clear();
    eMonth.add("01");
    eMonth.add("02");
    eMonth.add("03");
    eMonth.add("04");
    eMonth.add("05");
    eMonth.add("06");
    eMonth.add("07");
    eMonth.add("08");
    eMonth.add("09");
    eMonth.add("10");
    eMonth.add("11");
    eMonth.add("12");
    return eMonth;
  }

  static String getDate({required String date}) {
    switch (date) {
      case "1":
        return "01";
      case "2":
        return "02";
      case "3":
        return "03";
      case "4":
        return "04";
      case "5":
        return "05";
      case "6":
        return "06";
      case "7":
        return "07";
      case "8":
        return "08";
      case "9":
        return "09";
    }
    return date;
  }
}
