export 'connection/connection_unsupported.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart'
    if (dart.library.io) 'connection/connection_native.dart';
