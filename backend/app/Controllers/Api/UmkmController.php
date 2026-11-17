<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\UmkmModel;
use CodeIgniter\HTTP\ResponseInterface;
use Throwable;

/**
 * REST API CRUD UMKM.
 *
 *   GET    /api/umkm        -> daftar UMKM (mendukung ?page, ?per_page, ?q, ?kategori)
 *   GET    /api/umkm/{id}   -> detail satu UMKM
 *   POST   /api/umkm        -> tambah UMKM
 *   PUT    /api/umkm/{id}   -> ubah UMKM (seluruh field)
 *   DELETE /api/umkm/{id}   -> hapus UMKM
 *
 * Format response mengikuti slide: success, message, data, (meta), errors.
 */
class UmkmController extends BaseController
{
    /** Field yang ditampilkan ke client (sesuai contoh JSON di slide). */
    private const FIELDS = ['id', 'nama_umkm', 'pemilik', 'alamat', 'kategori', 'kontak'];

    private UmkmModel $model;

    public function __construct()
    {
        $this->model = new UmkmModel();
    }

    // ---------------------------------------------------------------- READ (list)
    public function index(): ResponseInterface
    {
        try {
            $page    = max(1, (int) ($this->request->getGet('page') ?? 1));
            $perPage = (int) ($this->request->getGet('per_page') ?? 10);
            $perPage = min(100, max(1, $perPage));
            $q        = trim((string) $this->request->getGet('q'));
            $kategori = trim((string) $this->request->getGet('kategori'));

            if ($q !== '') {
                $this->model->groupStart()
                    ->like('nama_umkm', $q)
                    ->orLike('pemilik', $q)
                    ->groupEnd();
            }
            if ($kategori !== '') {
                $this->model->where('kategori', $kategori);
            }

            $total = $this->model->countAllResults(false);
            $rows  = $this->model->orderBy('id', 'ASC')->findAll($perPage, ($page - 1) * $perPage);

            return $this->jsonSuccess(
                'Data UMKM berhasil diambil',
                array_map([$this, 'format'], $rows),
                200,
                [
                    'page'        => $page,
                    'per_page'    => $perPage,
                    'total'       => $total,
                    'total_pages' => (int) ceil($total / $perPage),
                ]
            );
        } catch (Throwable $e) {
            return $this->serverError($e);
        }
    }

    // ---------------------------------------------------------------- READ (detail)
    public function show(int $id): ResponseInterface
    {
        try {
            $row = $this->model->find($id);
            if ($row === null) {
                return $this->notFoundId($id);
            }

            return $this->jsonSuccess('Data UMKM berhasil diambil', $this->format($row));
        } catch (Throwable $e) {
            return $this->serverError($e);
        }
    }

    // ---------------------------------------------------------------- CREATE
    public function create(): ResponseInterface
    {
        try {
            $data = $this->payload();
            if ($data === null) {
                return $this->jsonError('Format JSON tidak valid', ['body' => 'Body request bukan JSON yang valid'], 400);
            }

            $errors = $this->runValidation($data);
            if ($errors !== []) {
                return $this->jsonError('Gagal menambahkan data UMKM', $errors, 400);
            }

            $id = $this->model->insert($this->onlyAllowed($data), true);

            return $this->jsonSuccess(
                'Data UMKM berhasil ditambahkan',
                $this->format($this->model->find($id)),
                201
            );
        } catch (Throwable $e) {
            return $this->serverError($e);
        }
    }

    // ---------------------------------------------------------------- UPDATE
    public function update(int $id): ResponseInterface
    {
        try {
            if ($this->model->find($id) === null) {
                return $this->notFoundId($id);
            }

            $data = $this->payload();
            if ($data === null) {
                return $this->jsonError('Format JSON tidak valid', ['body' => 'Body request bukan JSON yang valid'], 400);
            }

            $errors = $this->runValidation($data);
            if ($errors !== []) {
                return $this->jsonError('Gagal memperbarui data UMKM', $errors, 400);
            }

            $this->model->update($id, $this->onlyAllowed($data));

            return $this->jsonSuccess('Data UMKM berhasil diperbarui', $this->format($this->model->find($id)));
        } catch (Throwable $e) {
            return $this->serverError($e);
        }
    }

    // ---------------------------------------------------------------- DELETE
    public function delete(int $id): ResponseInterface
    {
        try {
            $row = $this->model->find($id);
            if ($row === null) {
                return $this->notFoundId($id, 'Gagal menghapus data UMKM');
            }

            $this->model->delete($id);

            return $this->jsonSuccess('Data UMKM berhasil dihapus', [
                'id'        => (int) $row['id'],
                'nama_umkm' => $row['nama_umkm'],
            ]);
        } catch (Throwable $e) {
            return $this->serverError($e);
        }
    }

    // ---------------------------------------------------------------- 404 untuk route /api/* yang tidak ada
    public function routeNotFound(): ResponseInterface
    {
        return $this->jsonError('Endpoint tidak ditemukan', [
            'endpoint' => 'Cek kembali URL dan HTTP method yang digunakan',
        ], 404);
    }

    // ================================================================ helper

    /** Response sukses: { success, message, data, [meta] } */
    private function jsonSuccess(string $message, mixed $data = null, int $status = 200, ?array $meta = null): ResponseInterface
    {
        $body = ['success' => true, 'message' => $message, 'data' => $data];
        if ($meta !== null) {
            $body['meta'] = $meta;
        }

        return $this->response->setStatusCode($status)->setJSON($body);
    }

    /** Response gagal: { success:false, message, errors } */
    private function jsonError(string $message, array $errors, int $status): ResponseInterface
    {
        return $this->response->setStatusCode($status)->setJSON([
            'success' => false,
            'message' => $message,
            'errors'  => (object) $errors,
        ]);
    }

    private function notFoundId(int $id, string $message = 'Data UMKM tidak ditemukan'): ResponseInterface
    {
        return $this->jsonError($message, ['id' => "UMKM dengan ID {$id} tidak ditemukan"], 404);
    }

    private function serverError(Throwable $e): ResponseInterface
    {
        log_message('error', '[API UMKM] ' . $e->getMessage());

        return $this->jsonError('Terjadi kesalahan pada server', [
            'server' => ENVIRONMENT === 'production' ? 'Silakan coba lagi nanti' : $e->getMessage(),
        ], 500);
    }

    /** Ambil body request: JSON (Content-Type: application/json) atau form-data / x-www-form-urlencoded. */
    private function payload(): ?array
    {
        $contentType = strtolower($this->request->getHeaderLine('Content-Type'));

        if (str_contains($contentType, 'application/json')) {
            $raw = trim((string) $this->request->getBody());
            if ($raw === '') {
                return [];
            }
            $decoded = json_decode($raw, true);

            return is_array($decoded) ? $decoded : null;
        }

        return $this->request->is('put')
            ? (array) $this->request->getRawInput()
            : (array) $this->request->getPost();
    }

    /** @return array<string,string> daftar error per field (kosong jika valid) */
    private function runValidation(array $data): array
    {
        $validation = service('validation');
        $validation->reset();
        $validation->setRules($this->model->getValidationRules(), $this->model->getValidationMessages());
        $validation->run($data);

        return $validation->getErrors();
    }

    private function onlyAllowed(array $data): array
    {
        $clean = array_intersect_key($data, array_flip($this->model->allowedFields));

        return array_map(static fn ($v) => is_string($v) ? trim($v) : $v, $clean);
    }

    private function format(array $row): array
    {
        $out = array_intersect_key($row, array_flip(self::FIELDS));
        $out['id'] = (int) $out['id'];

        return $out;
    }
}
