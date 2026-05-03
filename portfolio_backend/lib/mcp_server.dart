import 'dart:async';
import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';
import 'data/data_loader.dart';
import 'tools/portfolio_tools.dart';

/// An MCP server that exposes portfolio tools over any [StreamChannel].
///
/// This class is intended for standalone MCP protocol use (e.g. stdio).
/// For the HTTP chat endpoint see [PortfolioServer] in server.dart.
///
/// Usage (stdio):
/// ```dart
/// import 'dart:io';
/// import 'package:stream_channel/stream_channel.dart';
///
/// final channel = StreamChannel(stdin, stdout);
/// final server = PortfolioMcpServer.fromStreamChannel(channel, dataLoader: loader);
/// await server.initialized; // blocks until the MCP handshake completes
/// ```
base class PortfolioMcpServer extends MCPServer with ToolsSupport {
  final PortfolioTools _portfolioTools;

  PortfolioMcpServer.fromStreamChannel(
    StreamChannel<String> channel, {
    required DataLoader dataLoader,
  })  : _portfolioTools = PortfolioTools(dataLoader),
        super.fromStreamChannel(
          channel,
          implementation: Implementation(
            name: 'portfolio-mcp',
            version: '1.0.0',
          ),
        );

  /// Register all portfolio tools then delegate to [ToolsSupport.initialize].
  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    for (final tool in _portfolioTools.tools) {
      final handler = _portfolioTools.handlers[tool.name];
      if (handler != null) {
        registerTool(tool, handler);
      }
    }
    return super.initialize(request);
  }
}
