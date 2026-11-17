<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');

// ------------------------------------------------------------------
// REST API UMKM  ->  base URL: http://localhost:8080/api
// ------------------------------------------------------------------
$routes->group('api', ['namespace' => 'App\Controllers\Api'], static function (RouteCollection $routes): void {
    $routes->get('umkm', 'UmkmController::index');
    $routes->get('umkm/(:num)', 'UmkmController::show/$1');
    $routes->post('umkm', 'UmkmController::create');
    $routes->put('umkm/(:num)', 'UmkmController::update/$1');
    $routes->delete('umkm/(:num)', 'UmkmController::delete/$1');

    // Preflight CORS (dibutuhkan Flutter Web / browser). Response diisi oleh filter 'cors'.
    $routes->options('(:any)', static fn () => service('response')->setStatusCode(204));

    // Semua URL /api/* lain -> 404 dalam format JSON
    $routes->add('(:any)', 'UmkmController::routeNotFound');
});
