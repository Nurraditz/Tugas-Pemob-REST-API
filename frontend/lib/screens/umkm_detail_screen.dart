import 'package:flutter/material.dart';
import '../models/umkm.dart';

/// Halaman detail UMKM: menampilkan info lengkap satu data UMKM.
class UmkmDetailScreen extends StatelessWidget {
  final Umkm umkm;

  const UmkmDetailScreen({super.key, required this.umkm});

  Color _kategoriColor(String kategori) {
    switch (kategori) {
      case 'Kuliner':
        return Colors.orange;
      case 'Fashion':
        return Colors.pink;
      case 'Kerajinan':
        return Colors.teal;
      case 'Jasa':
        return Colors.blue;
      case 'Pertanian':
        return Colors.green;
      case 'Perdagangan':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _kategoriIcon(String kategori) {
    switch (kategori) {
      case 'Kuliner':
        return Icons.restaurant;
      case 'Fashion':
        return Icons.checkroom;
      case 'Kerajinan':
        return Icons.handyman;
      case 'Jasa':
        return Icons.build_circle;
      case 'Pertanian':
        return Icons.grass;
      case 'Perdagangan':
        return Icons.store;
      default:
        return Icons.business;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _kategoriColor(umkm.kategori);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail UMKM'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ───── Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _kategoriIcon(umkm.kategori),
                      size: 48,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    umkm.namaUmkm,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      umkm.kategori,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ───── Detail info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailTile(
                    icon: Icons.person_outline,
                    label: 'Pemilik',
                    value: umkm.pemilik,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: umkm.alamat,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Kontak',
                    value: umkm.kontak,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    icon: Icons.tag,
                    label: 'ID',
                    value: '#${umkm.id}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
