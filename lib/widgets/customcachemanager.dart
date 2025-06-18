import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(
  Config(
    'customCache',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 50,
    repo: JsonCacheInfoRepository(databaseName: 'customCache.db'),
    fileService: HttpFileService(),
  ),
);
