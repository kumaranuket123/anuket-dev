# portfolio_backend

Dart Shelf HTTP server with MCP tools that powers the AI chat widget on
[anuket.co.in](https://anuket.co.in).

## Architecture

```
Flutter Web → POST /chat → PortfolioServer (Shelf)
                                 │
                         Claude Agentic Loop
                         (claude-sonnet-4-20250514)
                                 │
                         PortfolioTools (dart_mcp)
                         ├── get_projects
                         ├── get_skills
                         ├── get_about
                         ├── get_experience
                         ├── check_availability
                         └── send_contact_message
                                 │
                         portfolio_data.json (loaded once at startup)
```

## Prerequisites

- Dart SDK **≥ 3.7.0**
- An Anthropic API key

## Run locally

```bash
# 1. Install dependencies
cd portfolio_backend
dart pub get

# 2. Set your Anthropic API key
export ANTHROPIC_API_KEY=sk-ant-...

# 3. Start the server (from the portfolio_backend/ directory)
#    The default JSON path is ../assets/data/portfolio_data.json
dart run lib/main.dart

# Or pass an explicit path to the JSON file
dart run lib/main.dart /absolute/path/to/portfolio_data.json

# Or override via environment variable
DATA_PATH=/path/to/portfolio_data.json dart run lib/main.dart
```

The server listens on **http://localhost:8080** by default.
Override the port with the `PORT` environment variable.

## Endpoints

| Method | Path      | Description                     |
|--------|-----------|---------------------------------|
| POST   | `/chat`   | AI chat — accepts `{"messages": [...]}`, returns `{"reply": "..."}` |
| GET    | `/health` | Returns `200 OK`                |

### Chat request format

```jsonc
POST /chat
Content-Type: application/json

{
  "messages": [
    { "role": "user", "content": "What projects has Anuket built?" }
  ]
}
```

Conversation history is stateless — the Flutter client sends the full message
history on every request.

## Environment variables

| Variable            | Default                                    | Description             |
|---------------------|--------------------------------------------|-------------------------|
| `ANTHROPIC_API_KEY` | *(required)*                               | Anthropic API key       |
| `PORT`              | `8080`                                     | HTTP listen port        |
| `DATA_PATH`         | `../assets/data/portfolio_data.json`       | Path to portfolio JSON  |

## MCP server (stdio)

`PortfolioMcpServer` in `lib/mcp_server.dart` implements the full MCP protocol
and can be connected to any MCP client via a `StreamChannel<String>`.  
This is separate from the HTTP server and intended for MCP-native integrations
(e.g. Claude Desktop).

## Production deployment

TODO: Deploy to a platform that supports Dart (Fly.io, Railway, Cloud Run).
Update the `_baseUrl` in
`lib/services/chat_service.dart` (Flutter project) to point to the deployed URL.
