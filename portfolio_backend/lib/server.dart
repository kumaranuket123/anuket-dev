import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'data/data_loader.dart';
import 'tools/portfolio_tools.dart';

/// Shelf HTTP server — POST /chat endpoint.
///
/// Backed by Groq (OpenAI-compatible API). Switch provider by changing
/// [_apiKey], [_model], and [_endpoint] only — the agentic loop is the same
/// for any OpenAI-compatible provider (Groq, OpenAI, OpenRouter, etc.).
class PortfolioServer {
  final PortfolioTools _portfolioTools;

  // TODO: Set GROQ_API_KEY in your environment before starting the server.
  // Free key (14,400 req/day) at: https://console.groq.com
  static final String _apiKey =
      Platform.environment['GROQ_API_KEY'] ?? '';

  // Groq free models with tool-calling support:
  //   llama-3.3-70b-versatile  — most capable (recommended)
  //   llama3-8b-8192           — faster, lighter
  static const String _model = 'llama-3.3-70b-versatile';
  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  // TODO: Replace [Anuket Kumar] with your preferred display name if different.
  static const String _systemPrompt =
      "You are a friendly AI assistant for Anuket Kumar's portfolio website. "
      "You help visitors learn about his projects, skills, work experience, "
      "and whether he is available for new work. "
      "Use the available tools to look up accurate details before answering. "
      "Keep answers concise and helpful. "
      "If asked something unrelated to the portfolio, politely redirect the "
      "visitor to portfolio-related topics.";

  PortfolioServer(DataLoader dataLoader)
      : _portfolioTools = PortfolioTools(dataLoader);

  // ---------------------------------------------------------------------------
  // Shelf handler
  // ---------------------------------------------------------------------------

  Handler get handler {
    final router = Router()
      ..post('/chat', _handleChat)
      ..get('/health', _handleHealth);

    return Pipeline()
        .addMiddleware(
          corsHeaders(headers: {
            ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            ACCESS_CONTROL_ALLOW_METHODS: 'POST, GET, OPTIONS',
            ACCESS_CONTROL_ALLOW_HEADERS: 'content-type',
          }),
        )
        .addMiddleware(logRequests())
        .addHandler(router.call);
  }

  Response _handleHealth(Request _) => Response.ok('OK');

  Future<Response> _handleChat(Request request) async {
    if (_apiKey.isEmpty) {
      return _jsonError(
        500,
        'GROQ_API_KEY is not set. '
        'Get a free key at https://console.groq.com',
      );
    }

    final body = await request.readAsString();
    Map<String, dynamic> payload;
    try {
      payload = json.decode(body) as Map<String, dynamic>;
    } catch (_) {
      return _jsonError(400, 'Request body must be valid JSON.');
    }

    final rawMessages = payload['messages'];
    if (rawMessages is! List) {
      return _jsonError(400, 'messages must be a JSON array.');
    }

    final messages =
        rawMessages.whereType<Map<String, dynamic>>().toList();

    try {
      final reply = await _runAgenticLoop(messages);
      return Response.ok(
        json.encode({'reply': reply}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, st) {
      stderr.writeln('[ERROR] $e\n$st');
      return _jsonError(500, 'Internal error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // OpenAI-compatible agentic loop (works for Groq, OpenAI, OpenRouter, etc.)
  // ---------------------------------------------------------------------------

  Future<String> _runAgenticLoop(
    List<Map<String, dynamic>> userMessages,
  ) async {
    final tools = _portfolioTools.openAiFormat;

    // System prompt goes as the first message in OpenAI-compatible APIs.
    final current = <Map<String, dynamic>>[
      {'role': 'system', 'content': _systemPrompt},
      ...userMessages,
    ];

    while (true) {
      final response = await _callApi(current, tools);

      final choices = response['choices'] as List<dynamic>;
      final choice = choices[0] as Map<String, dynamic>;
      final message = choice['message'] as Map<String, dynamic>;
      final finishReason = choice['finish_reason'] as String?;

      if (finishReason != 'tool_calls') {
        return (message['content'] as String? ?? '').trim();
      }

      // Append the assistant turn that carries the tool_calls list.
      current.add(message);

      // Execute every requested tool and add each result as a "tool" message.
      final toolCalls = message['tool_calls'] as List<dynamic>;
      for (final call in toolCalls) {
        final callMap = call as Map<String, dynamic>;
        final callId = callMap['id'] as String;
        final fn = callMap['function'] as Map<String, dynamic>;
        final toolName = fn['name'] as String;

        // OpenAI-compatible APIs send arguments as a JSON-encoded string.
        // Groq may send null for no-parameter tools — treat that as empty map.
        final argsJson = fn['arguments'] as String? ?? '{}';
        final decoded = json.decode(argsJson);
        final args = (decoded is Map<String, dynamic> ? decoded : <String, dynamic>{})
            .map((k, v) => MapEntry(k, v as Object?));

        final result = await _portfolioTools.callTool(toolName, args);

        current.add({
          'role': 'tool',
          'tool_call_id': callId,
          'content': result,
        });
      }
    }
  }

  Future<Map<String, dynamic>> _callApi(
    List<Map<String, dynamic>> messages,
    List<Map<String, Object?>> tools,
  ) async {
    final res = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'content-type': 'application/json',
      },
      body: json.encode({
        'model': _model,
        'messages': messages,
        'tools': tools,
        'tool_choice': 'auto',
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static Response _jsonError(int status, String message) => Response(
        status,
        body: json.encode({'error': message}),
        headers: {'content-type': 'application/json'},
      );
}
