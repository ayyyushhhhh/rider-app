import 'package:vector_map_tiles/vector_map_tiles.dart';

class OfflineMapService {
  String _urlTemplate({required String apiKey}) {
    return 'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/1/0/0.mvt?access_token=$apiKey';
  }

  VectorTileProvider cachingTileProvider({required String apiKey}) {
    return MemoryCacheVectorTileProvider(
        delegate: NetworkVectorTileProvider(
            urlTemplate: _urlTemplate(apiKey: apiKey), maximumZoom: 14),
        maxSizeBytes: 1024 * 1024 * 2);
  }
}
