class ChurchModel {
  final String id;
  final String churchId;
  final String name;
  final String city;
  final String address;
  final String street;
  final String number;
  final String postalCode;
  final String registerNumber;
  final String email;
  final DateTime? openingDate;
  final String lang;
  final String country;
  final String? wabaId;
  final String? phoneNumberId;
  final String? logoUrl;

  ChurchModel({
    required this.id,
    required this.churchId,
    required this.name,
    required this.city,
    required this.address,
    required this.street,
    required this.number,
    required this.postalCode,
    required this.registerNumber,
    required this.email,
    this.openingDate,
    this.lang = 'pt-BR',
    this.country = 'BR',
    this.wabaId,
    this.phoneNumberId,
    this.logoUrl,
  });

  factory ChurchModel.fromJson(Map<String, dynamic> json) {
    return ChurchModel(
      id: json['id'] ?? '',
      churchId: json['churchId'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      postalCode: json['postalCode'] ?? '',
      registerNumber: json['registerNumber'] ?? '',
      email: json['email'] ?? '',
      openingDate:
          json['openingDate'] != null
              ? DateTime.tryParse(json['openingDate'])
              : null,
      lang: json['lang'] ?? 'pt-BR',
      country: json['country'] ?? 'BR',
      wabaId: json['wabaId'],
      phoneNumberId: json['phoneNumberId'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'churchId': churchId,
      'name': name,
      'city': city,
      'address': address,
      'street': street,
      'number': number,
      'postalCode': postalCode,
      'registerNumber': registerNumber,
      'email': email,
      'openingDate': openingDate?.toIso8601String(),
      'lang': lang,
      'country': country,
      'wabaId': wabaId,
      'phoneNumberId': phoneNumberId,
      'logoUrl': logoUrl,
    };
  }

  ChurchModel copyWith({
    String? name,
    String? city,
    String? address,
    String? street,
    String? number,
    String? postalCode,
    String? registerNumber,
    String? email,
    DateTime? openingDate,
    String? lang,
    String? country,
    String? wabaId,
    String? phoneNumberId,
    String? logoUrl,
  }) {
    return ChurchModel(
      id: id,
      churchId: churchId,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      street: street ?? this.street,
      number: number ?? this.number,
      postalCode: postalCode ?? this.postalCode,
      registerNumber: registerNumber ?? this.registerNumber,
      email: email ?? this.email,
      openingDate: openingDate ?? this.openingDate,
      lang: lang ?? this.lang,
      country: country ?? this.country,
      wabaId: wabaId ?? this.wabaId,
      phoneNumberId: phoneNumberId ?? this.phoneNumberId,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
