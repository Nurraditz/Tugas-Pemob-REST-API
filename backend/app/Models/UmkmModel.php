<?php

namespace App\Models;

use CodeIgniter\Model;

class UmkmModel extends Model
{
    protected $table            = 'umkm';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
        'nama_umkm',
        'pemilik',
        'alamat',
        'kategori',
        'kontak',
    ];

    // created_at & updated_at diisi otomatis oleh CI4
    protected $useTimestamps = true;
    protected $dateFormat    = 'datetime';
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    /** Daftar kategori yang dianggap valid (dipakai juga oleh aplikasi Flutter). */
    public const KATEGORI = [
        'Kuliner',
        'Fashion',
        'Kerajinan',
        'Jasa',
        'Pertanian',
        'Perdagangan',
        'Lainnya',
    ];

    // Validasi dijalankan manual di controller (agar PUT juga mewajibkan semua field),
    // aturan & pesannya tetap disimpan di model supaya satu tempat.
    protected $skipValidation = true;

    protected $validationRules = [
        'nama_umkm' => 'required|min_length[3]|max_length[150]',
        'pemilik'   => 'required|min_length[3]|max_length[100]',
        'alamat'    => 'required|min_length[5]',
        'kategori'  => 'required|in_list[Kuliner,Fashion,Kerajinan,Jasa,Pertanian,Perdagangan,Lainnya]',
        'kontak'    => 'required|regex_match[/^(\+62|0)[0-9]{8,14}$/]',
    ];

    protected $validationMessages = [
        'nama_umkm' => [
            'required'   => 'Nama UMKM wajib diisi',
            'min_length' => 'Nama UMKM minimal 3 karakter',
            'max_length' => 'Nama UMKM maksimal 150 karakter',
        ],
        'pemilik' => [
            'required'   => 'Nama pemilik wajib diisi',
            'min_length' => 'Nama pemilik minimal 3 karakter',
            'max_length' => 'Nama pemilik maksimal 100 karakter',
        ],
        'alamat' => [
            'required'   => 'Alamat wajib diisi',
            'min_length' => 'Alamat minimal 5 karakter',
        ],
        'kategori' => [
            'required' => 'Kategori wajib diisi',
            'in_list'  => 'Kategori tidak valid',
        ],
        'kontak' => [
            'required'    => 'Kontak wajib diisi',
            'regex_match' => 'Kontak tidak valid (contoh: 08123456789)',
        ],
    ];
}
