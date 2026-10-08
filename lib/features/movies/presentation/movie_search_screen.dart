import 'package:flutter/material.dart';

import '../domain/get_movies.dart';
import '../domain/movie.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key, required this.getMovies});

  final GetMovies getMovies;

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  final _confirmationController = TextEditingController();
  Future<List<Movie>>? _moviesFuture;

  @override
  void dispose() {
    _queryController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  String? _validateQuery(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Escribe al menos 2 caracteres';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirma el texto de búsqueda';
    }
    if (value.trim().toLowerCase() !=
        _queryController.text.trim().toLowerCase()) {
      return 'Los textos de búsqueda no coinciden';
    }
    return null;
  }

  void _search() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _moviesFuture = widget.getMovies(_queryController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar películas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _queryController,
                    textInputAction: TextInputAction.next,
                    validator: _validateQuery,
                    decoration: const InputDecoration(
                      labelText: 'Película que quieres buscar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmationController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (_) => _search(),
                    validator: _validateConfirmation,
                    decoration: const InputDecoration(
                      labelText: 'Confirma la búsqueda',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _search,
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final future = _moviesFuture;
    if (future == null) {
      return const Center(child: Text('Confirma una búsqueda para comenzar'));
    }

    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No se encontraron películas',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final movies = snapshot.data ?? const <Movie>[];
        if (movies.isEmpty) {
          return const Center(child: Text('No se encontraron películas'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieTile(movie: movies[index]),
        );
      },
    );
  }
}

class _MovieTile extends StatelessWidget {
  const _MovieTile({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 76,
              height: 112,
              child: movie.posterUrl.isEmpty
                  ? const Icon(Icons.movie_outlined, size: 40)
                  : Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image_outlined, size: 40),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(movie.description),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(movie.rating == 0
                          ? 'Sin rating'
                          : '${movie.rating}/10'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
