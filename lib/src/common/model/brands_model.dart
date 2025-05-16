class BrandsModel {
  final String id;
  final String name;
  final String logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BrandsModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandsModel.fromJson(Map<String, dynamic> json) {
    return BrandsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// List<BrandsModel> dummyBrandsList = [
//   BrandsModel(
//     id: '1',
//     name: 'Brand A',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BrandsModel(
//     id: '2',
//     name: 'Brand B',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BrandsModel(
//     id: '3',
//     name: 'Brand C',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BrandsModel(
//     id: '4',
//     name: 'Brand D',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BrandsModel(
//     id: '5',
//     name: 'Brand E',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BrandsModel(
//     id: '6',
//     name: 'Brand F',
//     logoUrl:
//         'https://w7.pngwing.com/pngs/650/400/png-transparent-porsche-911-car-porsche-944-porsche-car-logo-brand-emblem-label-candle-thumbnail.png',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
// ];
