class Attendance {
  Attendance({
    this.attendanceIp,
    this.attendanceUid,
    this.attendanceStime,
    this.attendanceEtime,
    this.attendanceDates,
    this.type,
  });

  String? attendanceIp;
  String? attendanceUid;
  String? attendanceStime;
  String? attendanceEtime;
  String? attendanceDates;
  String? type;
}

class Enquiry {
  Enquiry({
    this.enquiryName,
    this.enquiryEmail,
    this.enquiryPhoneno,
    this.enquirySubject,
    this.enquiryMessage,
    this.enquiryEmp,
    this.enquiryUid,
    this.enquiryUtype,
    // this.type,
  });

  String? enquiryName;
  String? enquiryEmail;
  String? enquiryPhoneno;
  String? enquirySubject;
  String? enquiryMessage;
  String? enquiryEmp;
  String? enquiryUid;
  String? enquiryUtype;
// String? type;
}
