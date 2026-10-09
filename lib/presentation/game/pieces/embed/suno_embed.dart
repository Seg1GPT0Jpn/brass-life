/// Suno の埋め込みプレーヤー。Web では iframe でアプリ内に表示し、
/// それ以外の環境では案内だけを出す。
library;

export 'suno_embed_stub.dart'
    if (dart.library.js_interop) 'suno_embed_web.dart';
