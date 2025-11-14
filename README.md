# cloak.yazi

A yazi plugin that redacts environment variable values in `.env` files during preview.

## Features

- Automatically detects `.env` and `.env.*` files
- Redacts values while preserving keys
- Maintains file formatting (comments, blank lines, etc.)
- Handles quoted and unquoted values
- Preserves quote characters while redacting content

## Installation

This plugin is installed in your yazi config directory at:

```
~/.config/yazi/plugins/cloak.yazi/
```

## Configuration

Add these rules to your `yazi.toml` under the `[plugin]` section in `previewers`:

```toml
previewers = [
    # Environment files - redact values
    { name = "*.env", run = "cloak" },
    { name = ".env*", run = "cloak" },
    # ... other previewers
]
```

**Important**: These rules should be placed before the general `{ mime = "text/*", run = "code" }` rule so they take precedence.

## Example

Given a `.env` file:

```
API_KEY=super_secret_key_123
DATABASE_URL="postgresql://user:password@localhost/db"
DEBUG=true
# This is a comment
```

The preview will show:

```
API_KEY=********************
DATABASE_URL="***************************************"
DEBUG=****
# This is a comment
```

## How It Works

The plugin:

1. Intercepts preview requests for `.env` files
2. Reads the file content
3. Uses pattern matching to identify `KEY=VALUE` pairs
4. Replaces values with asterisks while preserving structure
5. Displays the redacted content in the preview pane

## Security Note

This plugin only affects the **preview** display in yazi. The actual file contents remain unchanged. This is useful for:

- Preventing shoulder surfing when browsing config files
- Screen sharing sessions
- Recording terminal sessions
- General security hygiene when working with sensitive files
