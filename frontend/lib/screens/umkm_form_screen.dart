import 'package:flutter/material.dart';
import '../models/umkm.dart';
import '../services/api_service.dart';

/// Halaman form: digunakan untuk Tambah (POST) dan Edit (PUT) data UMKM.
/// Jika [umkm] null → mode tambah (Create). Jika ada → mode edit (Update).
class UmkmFormScreen extends StatefulWidget {
  final Umkm? umkm;

  const UmkmFormScreen({super.key, this.umkm});

  @override
  State<UmkmFormScreen> createState() => _UmkmFormScreenState();
}

class _UmkmFormScreenState extends State<UmkmFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  late final TextEditingController _namaController;
  late final TextEditingController _pemilikController;
  late final TextEditingController _alamatController;
  late final TextEditingController _kontakController;
  late String _selectedKategori;

  bool get _isEditMode => widget.umkm != null;

  @override
  void initState() {
    super.initState();
    _namaController =
        TextEditingController(text: widget.umkm?.namaUmkm ?? '');
    _pemilikController =
        TextEditingController(text: widget.umkm?.pemilik ?? '');
    _alamatController =
        TextEditingController(text: widget.umkm?.alamat ?? '');
    _kontakController =
        TextEditingController(text: widget.umkm?.kontak ?? '');
    _selectedKategori = widget.umkm?.kategori ?? Umkm.kategoriList.first;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pemilikController.dispose();
    _alamatController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final umkm = Umkm(
      namaUmkm: _namaController.text.trim(),
      pemilik: _pemilikController.text.trim(),
      alamat: _alamatController.text.trim(),
      kategori: _selectedKategori,
      kontak: _kontakController.text.trim(),
    );

    try {
      if (_isEditMode) {
        // PUT request → Update
        await _apiService.updateUmkm(widget.umkm!.id!, umkm);
      } else {
        // POST request → Create
        await _apiService.createUmkm(umkm);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode
                ? 'Data UMKM berhasil diperbarui'
                : 'Data UMKM berhasil ditambahkan'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true); // return true → refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit UMKM' : 'Tambah UMKM'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ───── Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isEditMode ? Icons.edit_note : Icons.add_business,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isEditMode
                            ? 'Perbarui data UMKM yang sudah ada'
                            : 'Isi form berikut untuk menambahkan UMKM baru',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ───── Nama UMKM
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama UMKM',
                  hintText: 'Contoh: Warung Makan Barokah',
                  prefixIcon: const Icon(Icons.store_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama UMKM wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama UMKM minimal 3 karakter';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // ───── Pemilik
              TextFormField(
                controller: _pemilikController,
                decoration: InputDecoration(
                  labelText: 'Nama Pemilik',
                  hintText: 'Contoh: Ahmad Dani',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama pemilik wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama pemilik minimal 3 karakter';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // ───── Alamat
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Contoh: Jl. A. Yani No. 123, Banjarmasin',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  if (value.trim().length < 5) {
                    return 'Alamat minimal 5 karakter';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // ───── Kategori (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _selectedKategori,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: Umkm.kategoriList
                    .map((kat) => DropdownMenuItem(
                          value: kat,
                          child: Text(kat),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedKategori = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // ───── Kontak
              TextFormField(
                controller: _kontakController,
                decoration: InputDecoration(
                  labelText: 'Kontak (No. HP)',
                  hintText: 'Contoh: 08123456789',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kontak wajib diisi';
                  }
                  final regex = RegExp(r'^(\+62|0)[0-9]{8,14}$');
                  if (!regex.hasMatch(value.trim())) {
                    return 'Format tidak valid (contoh: 08123456789)';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),

              // ───── Tombol Submit
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(_isEditMode ? Icons.save : Icons.add),
                  label: Text(
                    _isLoading
                        ? 'Menyimpan...'
                        : (_isEditMode ? 'Simpan Perubahan' : 'Tambah UMKM'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

