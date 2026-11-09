import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: PhotoViewer()),
);

class Photo {
  final String title, subtitle, url;
  const Photo(this.title, this.subtitle, this.url);
}

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({super.key});
  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  static const _photos = [
    Photo(
      'Mountain Sunrise',
      'Nature · 8K',
      'https://picsum.photos/id/1018/1200/1600',
    ),
    Photo(
      'Forest Path',
      'Nature · 6K',
      'https://picsum.photos/id/1015/1200/1600',
    ),
    Photo(
      'Ocean Waves',
      'Nature · 8K',
      'https://picsum.photos/id/1043/1200/1600',
    ),
  ];

  final _pageCtrl = PageController();
  final _transformCtrl = TransformationController();
  int _index = 0;
  bool _showOverlay = true;
  double _scale = 1.0;
  final Set<int> _favorites = {};

  @override
  void dispose() {
    _pageCtrl.dispose();
    _transformCtrl.dispose();
    super.dispose();
  }

  void _toggleOverlay() => setState(() => _showOverlay = !_showOverlay);

  void _toggleFavorite([int? i]) {
    final idx = i ?? _index;
    setState(() {
      _favorites.contains(idx) ? _favorites.remove(idx) : _favorites.add(idx);
    });
    _snack(
      _favorites.contains(idx)
          ? '♥ Added to favorites'
          : 'Removed from favorites',
    );
  }

  void _resetZoom() {
    _transformCtrl.value = Matrix4.identity();
    setState(() => _scale = 1.0);
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(m),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1200),
        ),
      );
  }

  // ✅ Long press → action menu
  void _showMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Toggle Favorite'),
              onTap: () {
                Navigator.pop(ctx);
                _toggleFavorite();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Show Info'),
              onTap: () {
                Navigator.pop(ctx);
                if (!_showOverlay) _toggleOverlay();
              },
            ),
            ListTile(
              leading: const Icon(Icons.zoom_out_map),
              title: const Text('Reset Zoom'),
              onTap: () {
                Navigator.pop(ctx);
                _resetZoom();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Horizontal swipe between photos
            PageView.builder(
              controller: _pageCtrl,
              physics: _scale > 1.01
                  ? const NeverScrollableScrollPhysics() // ✅ pan when zoomed
                  : const PageScrollPhysics(),
              onPageChanged: (i) {
                _transformCtrl.value = Matrix4.identity();
                setState(() {
                  _index = i;
                  _scale = 1.0;
                });
              },
              itemCount: _photos.length,
              itemBuilder: (_, i) => _photoPage(i),
            ),

            // ✅ Info overlay — top
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: _showOverlay ? 0 : -110,
              left: 0,
              right: 0,
              child: _topOverlay(),
            ),

            // ✅ Accessible action bar — bottom
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: _showOverlay ? 0 : -110,
              left: 0,
              right: 0,
              child: _bottomBar(),
            ),

            // Favorite badge
            if (_favorites.contains(_index))
              const Positioned(
                top: 90,
                right: 20,
                child: Icon(Icons.favorite, color: Colors.pinkAccent, size: 28),
              ),

            // ✅ Scale indicator (visible feedback)
            if (_scale > 1.01)
              Positioned(
                bottom: 130,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_scale.toStringAsFixed(1)}×',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoPage(int i) {
    return GestureDetector(
      onTap: _toggleOverlay, // ✅ single tap
      onDoubleTap: () => _toggleFavorite(i), // ✅ double tap
      onLongPress: _showMenu, // ✅ long press
      child: InteractiveViewer(
        // ✅ pinch + pan
        transformationController: _transformCtrl,
        minScale: 1.0,
        maxScale: 4.0, // ✅ safe scale limits
        onInteractionUpdate: (_) {
          final s = _transformCtrl.value.getMaxScaleOnAxis();
          if ((s - _scale).abs() > 0.01) setState(() => _scale = s);
        },
        child: Center(
          child: Image.network(
            _photos[i].url,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, p) => p == null
                ? child
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 80, color: Colors.white54),
          ),
        ),
      ),
    );
  }

  Widget _topOverlay() {
    final photo = _photos[_index];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                photo.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                photo.subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${_index + 1} / ${_photos.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _btn(
            Icons.visibility,
            _showOverlay ? 'Hide Info' : 'Show Info',
            _toggleOverlay,
          ),
          _btn(
            _favorites.contains(_index)
                ? Icons.favorite
                : Icons.favorite_border,
            'Favorite',
            () => _toggleFavorite(),
            color: _favorites.contains(_index)
                ? Colors.pinkAccent
                : Colors.white,
          ),
          _btn(Icons.zoom_out_map, 'Reset', _resetZoom),
        ],
      ),
    );
  }

  Widget _btn(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
