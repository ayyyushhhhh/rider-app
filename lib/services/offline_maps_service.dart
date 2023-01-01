import 'package:vector_map_tiles/vector_map_tiles.dart';

class OfflineMapService {
  String _urlTemplate({required String apiKey}) {
    return "https://api.mapbox.com/styles/v1/ayyyushhhhh/clc94ph3j005r14n6qft3xz7u/tiles/256/{z}/{x}/{y}@2x?access_token=$apiKey";
  }

  VectorTileProvider cachingTileProvider({required String apiKey}) {
    return MemoryCacheVectorTileProvider(
        delegate: NetworkVectorTileProvider(
            urlTemplate: _urlTemplate(apiKey: apiKey), maximumZoom: 14),
        maxSizeBytes: 1024 * 1024 * 2);
  }
}
