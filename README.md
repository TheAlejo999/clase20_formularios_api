# Clase 20 — Formularios y consumo de APIs

Proyecto de la clase 20 de Desarrollo de Aplicaciones Móviles (ESEN, ciclo 3/2026).

## ¿Qué hace?

Busca películas usando la API de [OMDb](https://www.omdbapi.com/).
El formulario tiene dos campos: el título que quieres buscar y una confirmación del mismo.
Ambos tienen que coincidir para que la búsqueda se dispare (validación cruzada).

## Por qué OMDb y no la API oficial de IMDb

La API oficial de IMDb está disponible a través de AWS Data Exchange, usa GraphQL
y es de pago. OMDb es una alternativa REST gratuita (con registro) que expone datos
de IMDb de forma sencilla, sin GraphQL ni costos asociados.

## Conceptos que cubre

- Validación cruzada: el `validator` de un campo lee el `.text` del controlador de otro campo al momento de `Form.validate()`.
- Consumo de API REST con el paquete `http`.
- `fromJson` para convertir el JSON de la respuesta en objetos Dart.
- `FutureBuilder` con sus tres estados: cargando, error y datos.

## Configuración

La API key de OMDb se inyecta en tiempo de compilación con `--dart-define`.
**No se usa ningún archivo `.env` en el binario**, por lo que la key nunca queda
embebida en el APK/IPA.

Obtén una key gratuita en [omdbapi.com](https://www.omdbapi.com/apikey.aspx).

## Correr el proyecto

```bash
flutter pub get
flutter run --dart-define=OMDB_API_KEY=tu_key_aqui
```

## Compilar para producción

```bash
# Android
flutter build apk --dart-define=OMDB_API_KEY=tu_key_aqui

# iOS
flutter build ios --dart-define=OMDB_API_KEY=tu_key_aqui
```

## Estructura del proyecto

```
lib/
├── main.dart
└── features/
    └── movies/
        ├── data/
        │   ├── movie_model.dart           # fromJson
        │   ├── movie_remote_data_source.dart  # llamadas HTTP a OMDb
        │   └── movie_repository_impl.dart
        ├── domain/
        │   ├── movie.dart
        │   ├── movie_repository.dart
        │   └── get_movies.dart            # caso de uso
        └── presentation/
            └── movie_search_screen.dart   # UI + FutureBuilder
```
