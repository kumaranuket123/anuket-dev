import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sends chat messages to the portfolio backend and returns Claude's reply.
class ChatService {
  // TODO: Change to your production backend URL before deploying.
  static const String _baseUrl = 'http://localhost:8080';

  /// Sends the full [messages] history to POST /chat and returns the reply.
  ///
  /// Each entry must have the shape {"role": "user"|"assistant", "content": "..."}.
  Future<String> sendMessages(List<Map<String, String>> messages) async {
    final uri = Uri.parse('$_baseUrl/chat');

    final response = await http
        .post(
          uri,
          headers: {'content-type': 'application/json'},
          body: json.encode({'messages': messages}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Backend returned ${response.statusCode}: ${response.body}',
      );
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return (data['reply'] as String?)?.trim() ?? 'No reply received.';
  }
}
