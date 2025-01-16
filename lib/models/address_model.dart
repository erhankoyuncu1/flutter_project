class AddressModel {
  final String id;
  final String title;
  final String fullAddress;
  final bool isActive;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.isActive,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'isActive': isActive,
    };
  }
}
