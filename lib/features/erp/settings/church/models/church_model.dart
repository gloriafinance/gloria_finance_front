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
  final bool isWhatsappConnected;
  final String? logoUrl;
  final List<ChurchDoctrinalBaseModel> doctrinalBases;

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
    this.isWhatsappConnected = false,
    this.logoUrl,
    this.doctrinalBases = const [],
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
      isWhatsappConnected: json['isWhatsappConnected'] == true,
      logoUrl: json['logoUrl'],
      doctrinalBases:
          (json['doctrinalBases'] as List?)
              ?.whereType<Map>()
              .map(
                (item) => ChurchDoctrinalBaseModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
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
      'isWhatsappConnected': isWhatsappConnected,
      'logoUrl': logoUrl,
      'doctrinalBases': doctrinalBases.map((item) => item.toJson()).toList(),
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
    bool? isWhatsappConnected,
    String? logoUrl,
    List<ChurchDoctrinalBaseModel>? doctrinalBases,
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
      isWhatsappConnected: isWhatsappConnected ?? this.isWhatsappConnected,
      logoUrl: logoUrl ?? this.logoUrl,
      doctrinalBases: doctrinalBases ?? this.doctrinalBases,
    );
  }
}

class ChurchDoctrinalBaseModel {
  final String title;
  final String scripture;

  const ChurchDoctrinalBaseModel({
    required this.title,
    required this.scripture,
  });

  factory ChurchDoctrinalBaseModel.fromJson(Map<String, dynamic> json) {
    return ChurchDoctrinalBaseModel(
      title: json['title']?.toString() ?? '',
      scripture: json['scripture']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'scripture': scripture};
  }

  ChurchDoctrinalBaseModel copyWith({String? title, String? scripture}) {
    return ChurchDoctrinalBaseModel(
      title: title ?? this.title,
      scripture: scripture ?? this.scripture,
    );
  }
}
