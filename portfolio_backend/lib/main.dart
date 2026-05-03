import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'data/data_loader.dart';
import 'server.dart';

Future<void> main(List<String> args) async {
  // ---------------------------------------------------------------------------
  // Load portfolio data
  // ---------------------------------------------------------------------------
  final dataLoader = DataLoader();
  // Pass an explicit path as the first CLI argument, or set DATA_PATH env var.
  // Defaults to ../assets/data/portfolio_data.json (relative to this package).
  final dataPath = args.isNotEmpty ? args[0] : null;

  try {
    await dataLoader.load(dataPath);
    stdout.writeln('[INFO] Portfolio data loaded successfully.');
  } catch (e) {
    stderr.writeln('[FATAL] Could not load portfolio data: $e');
    exit(1);
  }

  // ---------------------------------------------------------------------------
  // Start HTTP server
  // ---------------------------------------------------------------------------
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final server = PortfolioServer(dataLoader);

  final httpServer = await shelf_io.serve(server.handler, '0.0.0.0', port);
  stdout.writeln('[INFO] Portfolio backend listening on '
      'http://localhost:${httpServer.port}');
  stdout.writeln('[INFO]   POST /chat   — AI chat endpoint');
  stdout.writeln('[INFO]   GET  /health — Health check');
}
