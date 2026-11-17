/// Model class untuk data UMKM.
/// Mapping JSON ↔ Dart object (JSON Parsing).
class Umkm {
  final int? id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;

  Umkm({
    this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
  });

  /// Factory constructor: JSON → Umkm (JSON Parsing / Deserialization)
  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: json['id'] as int?,
      namaUmkm: json['nama_umkm'] as String? ?? '',
      pemilik: json['pemilik'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
      kontak: json['kontak'] as String? ?? '',
    );
  }

  /// Convert Umkm → JSON Map (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'nama_umkm': namaUmkm,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };
  }

  /// Daftar kategori (sama dengan backend)
  static const List<String> kategoriList = [
    'Kuliner',
    'Fashion',
    'Kerajinan',
    'Jasa',
    'Pertanian',
    'Perdagangan',
    'Lainnya',
  ];
}
