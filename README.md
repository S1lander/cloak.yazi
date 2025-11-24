# cloak.yazi

A yazi plugin that redacts environment variable values in `.env` files during preview.

## ⭐ Features

- Automatically detects `.env` files and redacts values while preserving keys
- Maintains file formatting (comments, blank lines, etc.)
- Handles quoted and unquoted values
- Preserves quote characters while redacting content

## 🚀 Installation

1. Navigate to:
   ```bash
   ~/.config/yazi/plugins/cloak.yazi/
   ```
1. Clone the repo:
   ```bash
   git clone https://github.com/S1lander/cloak.yazi.git
   ```
1. Adjust the config 👇🏼

## ⚙️ Configuration

Add these rules to your `~/.config/yazi/yazi.toml` under the `[plugin]` section in `previewers`:

```toml
previewers = [
    # Environment files - redact values
  { name = "*.env", run = "cloak" },
  { name = "*.env.*", run = "cloak" },
  { name = ".env", run = "cloak" },
  { name = ".env*", run = "cloak" },
    # ... other previewers
]
```

**Important**: These rules should be placed before the general `{ mime = "text/*", run = "code" }` rule so they take precedence.

## 💡 Example

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

## ℹ️ How It Works

The plugin:

1. Intercepts preview requests for `.env` files
1. Reads the file content
1. Uses pattern matching to identify `KEY=VALUE` pairs
1. Replaces values with asterisks while preserving structure
1. Displays the redacted content in the preview pane

## ❗ Security Note

This plugin only affects the **preview** display in yazi. The actual file contents remain unchanged. This is useful for:

- Preventing shoulder surfing when browsing config files
- Screen sharing sessions
- Recording terminal sessions
- General security hygiene when working with sensitive files
