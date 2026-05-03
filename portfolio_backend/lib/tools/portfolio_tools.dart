import 'dart:async';
import 'dart:convert';
import 'package:dart_mcp/server.dart';
import '../data/data_loader.dart';

/// Defines all MCP tools and their handlers using dart_mcp types.
///
/// Tools read from [DataLoader] which was populated at startup.
/// The [handlers] map is used both by [PortfolioMcpServer] (for stdio MCP use)
/// and by [PortfolioServer] (for the Claude agentic loop over HTTP).
class PortfolioTools {
  final DataLoader _dataLoader;

  PortfolioTools(this._dataLoader);

  // ---------------------------------------------------------------------------
  // Tool definitions (dart_mcp types → also drives Anthropic API format)
  // ---------------------------------------------------------------------------

  List<Tool> get tools => [
        Tool(
          name: 'get_projects',
          description:
              'Returns all portfolio projects including title, description, '
              'tech stack, and links.',
          inputSchema: ObjectSchema(),
        ),
        Tool(
          name: 'get_skills',
          description:
              'Returns the skills and technical expertise listed on the portfolio.',
          inputSchema: ObjectSchema(),
        ),
        Tool(
          name: 'get_about',
          description:
              'Returns bio, personal description, and background of Anuket Kumar.',
          inputSchema: ObjectSchema(),
        ),
        Tool(
          name: 'get_experience',
          description: 'Returns work experience and job history.',
          inputSchema: ObjectSchema(),
        ),
        Tool(
          name: 'check_availability',
          description:
              'Returns availability for new projects, freelance work, '
              'and contact details.',
          inputSchema: ObjectSchema(),
        ),
        Tool(
          name: 'send_contact_message',
          description:
              "Send a contact message to Anuket on behalf of a visitor. "
              "Use this when the visitor wants to get in touch.",
          inputSchema: ObjectSchema(
            properties: {
              'name': StringSchema(description: "The visitor's name"),
              'email': StringSchema(description: "The visitor's email address"),
              'message': StringSchema(description: 'The message to send'),
            },
            required: ['name', 'email', 'message'],
          ),
        ),
      ];

  // ---------------------------------------------------------------------------
  // Handlers keyed by tool name — used by both MCPServer and the HTTP chat loop
  // ---------------------------------------------------------------------------

  Map<String, FutureOr<CallToolResult> Function(CallToolRequest)>
      get handlers => {
            'get_projects': (_) => CallToolResult(
                  content: [
                    TextContent(text: json.encode(_dataLoader.projects)),
                  ],
                ),
            'get_skills': (_) => CallToolResult(
                  content: [
                    TextContent(
                      text: json.encode(_dataLoader.about['skills']),
                    ),
                  ],
                ),
            'get_about': (_) {
              // Omit the image path — not useful in a text context.
              final about = Map<String, dynamic>.from(_dataLoader.about)
                ..remove('profileIcon');
              final hero = Map<String, dynamic>.from(_dataLoader.hero)
                ..remove('imagePath')
                ..remove('buttonText')
                ..remove('resumeLink');
              return CallToolResult(
                content: [
                  TextContent(text: json.encode({...hero, ...about})),
                ],
              );
            },
            'get_experience': (_) => CallToolResult(
                  content: [
                    TextContent(text: json.encode(_dataLoader.experience)),
                  ],
                ),
            'check_availability': (_) {
              final c = _dataLoader.contact;
              return CallToolResult(
                content: [
                  TextContent(
                    text: json.encode({
                      'available_for_work': true,
                      'description': c['description'],
                      'email': c['email'],
                      'meeting_link': c['meetingLink'],
                      'socials': c['socials'],
                    }),
                  ),
                ],
              );
            },
            'send_contact_message': (request) {
              final args = request.arguments ?? {};
              final name = args['name'] as String? ?? 'Unknown';
              final email = args['email'] as String? ?? 'Unknown';
              final message = args['message'] as String? ?? '';

              // TODO: Wire to an email service (e.g. SendGrid) or store in a DB.
              print('[CONTACT] From : $name <$email>');
              print('[CONTACT] Message: $message');

              return CallToolResult(
                content: [
                  TextContent(
                    text:
                        'Message received! Anuket will get back to you at '
                        '$email soon.',
                  ),
                ],
              );
            },
          };

  // ---------------------------------------------------------------------------
  // Helpers for the Anthropic API agentic loop
  // ---------------------------------------------------------------------------

  /// Converts dart_mcp [Tool] definitions to the OpenAI-compatible tool format.
  ///
  /// Works with Groq, OpenAI, OpenRouter, and any OpenAI-compatible provider.
  List<Map<String, Object?>> get openAiFormat => tools
      .map(
        (t) => <String, Object?>{
          'type': 'function',
          'function': {
            'name': t.name,
            'description': t.description ?? '',
            // ObjectSchema is an extension type over Map — serialises directly.
            'parameters': t.inputSchema,
          },
        },
      )
      .toList();

  /// Executes [name] with [args] and returns the plain-text result.
  Future<String> callTool(String name, Map<String, Object?> args) async {
    final handler = handlers[name];
    if (handler == null) return 'Unknown tool: $name';

    final result = await handler(CallToolRequest(name: name, arguments: args));
    return result.content
        .whereType<TextContent>()
        .map((c) => c.text)
        .join('\n');
  }
}
