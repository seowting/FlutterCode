class Tutors {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorPassword;
  String? tutorDescription;
  String? tutorDatereg;
  String? subjectList;

  Tutors({
    this.tutorId,
    this.tutorEmail,
    this.tutorPhone,
    this.tutorName,
    this.tutorPassword,
    this.tutorDescription,
    this.tutorDatereg,
    this.subjectList,
  });

  Tutors.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorPassword = json['tutor_password'];
    tutorDescription = json['tutor_description'];
    tutorDatereg = json['tutor_datereg'];
    subjectList = json['subject_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorId;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] = tutorPhone;
    data['tutor_name'] = tutorName;
    data['tutor_password'] = tutorPassword;
    data['tutor_description'] = tutorDescription;
    data['tutor_datereg'] = tutorDatereg;
    data['subject_list'] = subjectList;
    return data;
  }
}
