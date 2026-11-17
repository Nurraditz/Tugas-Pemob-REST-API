import 'package:flutter/material.dart';
import '../models/umkm.dart';

/// Widget kartu untuk menampilkan data UMKM di list.
/// Desain Material Design 3 dengan warna kategori.
class UmkmCard extends StatelessWidget {
  final Umkm umkm;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UmkmCard({
    super.key,
    required this.umkm,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  /// Warna berdasarkan kategori
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

  /// Icon berdasarkan kategori
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Nama UMKM + Badge Kategori
              Row(
                children: [
                  // Icon kategori
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_kategoriIcon(umkm.kategori),
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  // Nama + Pemilik
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          umkm.namaUmkm,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          umkm.pemilik,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Kategori
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      umkm.kategori,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Info: Alamat + Kontak
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      umkm.alamat,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone_outlined,
                      size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    umkm.kontak,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
