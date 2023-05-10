class FileModel {
  String fileName;
  late double ratingValue;
  final String rateID;
  final String fileID;
  final String uploader;
  String value;
  double average;
  String updateid;

  FileModel({
    required this.fileName,
    required this.ratingValue,
    required this.rateID,
    required this.uploader,
    required this.fileID,
    required this.value,
    required this.average,
    required this.updateid
  });
}