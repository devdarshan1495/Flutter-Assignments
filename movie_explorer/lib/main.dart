import 'package:flutter/material.dart';

void main() {
  runApp(const MovieExplorerApp());
}

class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        scaffoldBackgroundColor: Colors.grey.shade100,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Movie {
  final String title;
  final String category;
  final int year;
  final double rating;
  final String genre;
  final String imageUrl;
  final String description;

  const Movie({
    required this.title,
    required this.category,
    required this.year,
    required this.rating,
    required this.genre,
    required this.imageUrl,
    required this.description,
  });
}

const List<Movie> movies = [
  Movie(
    title: 'Interstellar',
    category: 'Sci-Fi',
    year: 2014,
    rating: 8.7,
    genre: 'Adventure, Drama, Sci-Fi',
    imageUrl: 'https://picsum.photos/seed/interstellar/400/600',
    description:
        'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
  ),
  Movie(
    title: 'Inception',
    category: 'Sci-Fi',
    year: 2010,
    rating: 8.8,
    genre: 'Action, Sci-Fi, Thriller',
    imageUrl: 'https://picsum.photos/seed/inception/400/600',
    description:
        'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.',
  ),
  Movie(
    title: 'The Dark Knight',
    category: 'Action',
    year: 2008,
    rating: 9.0,
    genre: 'Action, Crime, Drama',
    imageUrl: 'https://picsum.photos/seed/darkknight/400/600',
    description:
        'Batman faces the Joker, a criminal mastermind who plunges Gotham into anarchy.',
  ),
  Movie(
    title: 'Parasite',
    category: 'Thriller',
    year: 2019,
    rating: 8.5,
    genre: 'Drama, Thriller',
    imageUrl: 'https://picsum.photos/seed/parasite/400/600',
    description:
        'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
  ),
  Movie(
    title: 'La La Land',
    category: 'Romance',
    year: 2016,
    rating: 8.0,
    genre: 'Comedy, Drama, Music',
    imageUrl: 'https://picsum.photos/seed/lalaland/400/600',
    description:
        'A jazz pianist and an aspiring actress fall in love while pursuing their dreams in Los Angeles.',
  ),
  Movie(
    title: 'Pulp Fiction',
    category: 'Crime',
    year: 1994,
    rating: 8.9,
    genre: 'Crime, Drama',
    imageUrl: 'https://picsum.photos/seed/pulpfiction/400/600',
    description:
        'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.',
  ),
  Movie(
    title: 'Toy Story',
    category: 'Animation',
    year: 1995,
    rating: 8.3,
    genre: 'Animation, Adventure, Comedy',
    imageUrl: 'https://picsum.photos/seed/toystory/400/600',
    description:
        'A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy.',
  ),
  Movie(
    title: 'Titanic',
    category: 'Drama',
    year: 1997,
    rating: 7.9,
    genre: 'Drama, Romance',
    imageUrl: 'https://picsum.photos/seed/titanic/400/600',
    description:
        'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
  ),
];

const List<String> categories = [
  'All',
  'Sci-Fi',
  'Action',
  'Thriller',
  'Romance',
  'Crime',
  'Animation',
  'Drama',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<String> _watchlist = [];

  void _toggleWatchlist(String title) {
    setState(() {
      if (_watchlist.contains(title)) {
        _watchlist.remove(title);
      } else {
        _watchlist.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeTab(
        onAddToWatchlist: _toggleWatchlist,
        watchlist: _watchlist,
      ),
      CategoryListing(
        onSelectCategory: _selectCategory,
        watchlist: _watchlist,
        onToggleWatchlist: _toggleWatchlist,
      ),
      _WatchlistTab(
        watchlist: _watchlist,
        onAddToWatchlist: _toggleWatchlist,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie Explorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E88E5),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Browse'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }

  void _selectCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieListingScreen(
          category: category,
          watchlist: _watchlist,
          onToggleWatchlist: _toggleWatchlist,
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  final void Function(String) onAddToWatchlist;
  final List<String> watchlist;

  const _HomeTab({required this.onAddToWatchlist, required this.watchlist});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final ScrollController _trendingController = ScrollController();
  final ValueNotifier<double> _trendingOffset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _trendingController.addListener(() {
      _trendingOffset.value = _trendingController.hasClients
          ? _trendingController.offset
          : 0;
    });
  }

  void _scrollTrending(double delta) {
    if (!_trendingController.hasClients) return;
    _trendingController.animateTo(
      (_trendingController.offset + delta).clamp(
        0,
        _trendingController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 22),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black54,
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onPressed,
    );
  }

  @override
  void dispose() {
    _trendingController.dispose();
    _trendingOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Now',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 220,
                child: ListView.builder(
                  controller: _trendingController,
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) => _TrendingCard(
                    movie: movies[index],
                    inWatchlist: widget.watchlist.contains(movies[index].title),
                    onAdd: () => widget.onAddToWatchlist(movies[index].title),
                    watchlist: widget.watchlist,
                    onToggleWatchlist: widget.onAddToWatchlist,
                  ),
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: _trendingOffset,
                builder: (context, pixels, child) {
                  double maxExtent = 0;
                  if (_trendingController.hasClients &&
                      _trendingController.position.hasContentDimensions) {
                    maxExtent = _trendingController.position.maxScrollExtent;
                  }
                  bool atStart = pixels <= 0;
                  bool atEnd = maxExtent <= 0 || pixels >= maxExtent;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!atStart)
                        _arrowButton(
                          Icons.arrow_back_ios_new,
                          () => _scrollTrending(-300),
                        ),
                      if (!atEnd)
                        _arrowButton(
                          Icons.arrow_forward_ios,
                          () => _scrollTrending(300),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Explore Categories',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories
                .where((c) => c != 'All')
                .map(
                  (c) => SizedBox(
                    width: 260,
                    child: _CategoryCard(
                      category: c,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieListingScreen(
                            category: c,
                            watchlist: widget.watchlist,
                            onToggleWatchlist: widget.onAddToWatchlist,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final Movie movie;
  final bool inWatchlist;
  final VoidCallback onAdd;
  final List<String> watchlist;
  final void Function(String) onToggleWatchlist;

  const _TrendingCard({
    required this.movie,
    required this.inWatchlist,
    required this.onAdd,
    required this.watchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailScreen(
            movie: movie,
            watchlist: watchlist,
            onToggleWatchlist: onToggleWatchlist,
          ),
        ),
      ),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                movie.imageUrl,
                width: 140,
                height: 220,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    inWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    color: inWatchlist ? Colors.amber : Colors.white,
                  ),
                  onPressed: onAdd,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _CategoryCard extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'Sci-Fi': Icons.rocket_launch,
      'Action': Icons.flash_on,
      'Thriller': Icons.psychology,
      'Romance': Icons.favorite,
      'Crime': Icons.gavel,
      'Animation': Icons.animation,
      'Drama': Icons.theater_comedy,
    };
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icons[category], color: const Color(0xFF1E88E5), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryListing extends StatelessWidget {
  final void Function(String category) onSelectCategory;
  final List<String> watchlist;
  final void Function(String) onToggleWatchlist;

  const CategoryListing({
    super.key,
    required this.onSelectCategory,
    required this.watchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: categories
          .where((c) => c != 'All')
          .map(
            (c) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1E88E5),
                  child: Icon(_categoryIcon(c), color: Colors.white),
                ),
                title: Text(c, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieListingScreen(
                      category: c,
                      watchlist: watchlist,
                      onToggleWatchlist: onToggleWatchlist,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  IconData _categoryIcon(String c) {
    return {
      'Sci-Fi': Icons.rocket_launch,
      'Action': Icons.flash_on,
      'Thriller': Icons.psychology,
      'Romance': Icons.favorite,
      'Crime': Icons.gavel,
      'Animation': Icons.animation,
      'Drama': Icons.theater_comedy,
    }[c]!;
  }
}

class MovieListingScreen extends StatelessWidget {
  final String category;
  final List<String> watchlist;
  final void Function(String) onToggleWatchlist;

  const MovieListingScreen({
    super.key,
    required this.category,
    required this.watchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final categoryMovies =
        movies.where((m) => m.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.grey.shade100,
      ),
      body: categoryMovies.isEmpty
          ? const Center(child: Text('No movies in this category.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                mainAxisExtent: 250,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemCount: categoryMovies.length,
              itemBuilder: (context, index) {
                final movie = categoryMovies[index];
                return _ListingCard(
                  movie: movie,
                  watchlist: watchlist,
                  onToggleWatchlist: onToggleWatchlist,
                );
              },
            ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Movie movie;
  final List<String> watchlist;
  final void Function(String) onToggleWatchlist;

  const _ListingCard({
    required this.movie,
    required this.watchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailScreen(
            movie: movie,
            watchlist: watchlist,
            onToggleWatchlist: onToggleWatchlist,
          ),
        ),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      movie.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${movie.rating}', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${movie.year} • ${movie.genre}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final List<String> watchlist;
  final void Function(String) onToggleWatchlist;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.watchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    bool inWatchlist = watchlist.contains(movie.title);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 28,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(movie.imageUrl, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.grey.shade100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${movie.rating}'),
                      const SizedBox(width: 12),
                      Text('${movie.year}'),
                      const SizedBox(width: 12),
                      Text(movie.genre),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            inWatchlist ? Icons.bookmark : Icons.bookmark_border,
                          ),
                          label: Text(
                            inWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                          ),
                          onPressed: () {
                            onToggleWatchlist(movie.title);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  inWatchlist
                                      ? 'Removed "${movie.title}" from watchlist'
                                      : 'Added "${movie.title}" to watchlist',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  final List<String> watchlist;
  final void Function(String) onAddToWatchlist;

  const _WatchlistTab({required this.watchlist, required this.onAddToWatchlist});

  @override
  Widget build(BuildContext context) {
    if (watchlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 12),
            const Text(
              'Your watchlist is empty.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Add movies to save them here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final watchlistMovies =
        movies.where((m) => watchlist.contains(m.title)).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: watchlistMovies.length,
      itemBuilder: (context, index) {
        final movie = watchlistMovies[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.imageUrl,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              movie.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${movie.year} • ${movie.category}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(
                  movie: movie,
                  watchlist: watchlist,
                  onToggleWatchlist: onAddToWatchlist,
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => onAddToWatchlist(movie.title),
            ),
          ),
        );
      },
    );
  }
}
