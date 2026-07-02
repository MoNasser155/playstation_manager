import 'dart:async';
import 'dart:io';

class LocalAuthServer {
  static const int _port = 54321;
  HttpServer? _server;

  String get callbackUrl => 'http://localhost:$_port';

  Future<Uri> waitForCallback() async {
    final completer = Completer<Uri>(); 

    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, _port);

    _server!.listen((HttpRequest req) async {
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.html
        ..write('''<!DOCTYPE html><html>
<head><meta charset="utf-8"><title>Auth Complete</title></head>
<body style="font-family:sans-serif;display:flex;justify-content:center;
             align-items:center;height:100vh;margin:0;background:#101922;color:#fff">
  <div style="text-align:center">
    <div style="font-size:64px;margin-bottom:16px">✅</div>
    <h2 style="margin:0 0 8px;font-size:24px;font-weight:600">Authentication complete</h2>
    <p style="margin:0;color:#9CA3AF;font-size:15px">
      You may close this tab and return to the app.
    </p>
    <script>setTimeout(()=>window.close(),1500)</script>
  </div>
</body></html>''');
      await req.response.close();

      if (!completer.isCompleted) {
        completer.complete(req.requestedUri);
      }

      await _server?.close(force: true);
      _server = null;
    });

    return completer.future;
  }

  Future<void> dispose() async {
    await _server?.close(force: true);
    _server = null;
  }
}
