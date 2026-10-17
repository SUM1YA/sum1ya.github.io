
#!/usr/bin/env bash
set -euo pipefail

OUTPUT="index.html"
TITLE="My HTML Apps"

# Generate the HTML homepage
cat > "$OUTPUT" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My HTML Apps</title>
  <style>
    * { box-sizing: border-box; }

    body {
      font-family: Arial, sans-serif;
      background: #f3f4f6;
      color: #1f2937;
      margin: 0;
      padding: 30px 16px;
    }

    main {
      max-width: 700px;
      margin: auto;
    }

    h1 { text-align: center; }

    .apps {
      display: grid;
      gap: 12px;
      margin-top: 28px;
    }

    .apps a {
      display: block;
      padding: 18px 20px;
      background: white;
      border-radius: 12px;
      text-decoration: none;
      color: #2563eb;
      font-weight: bold;
      box-shadow: 0 2px 8px #0001;
      overflow-wrap: anywhere;
    }

    .apps a:hover { background: #dbeafe; }
  </style>
</head>
<body>
  <main>
    <h1>My HTML Apps</h1>
    <p>Choose an application to open.</p>
    <div class="apps">
HTML

# Find HTML files in this folder, excluding index.html.
# Sort filenames and escape HTML-sensitive characters in links.
find . -maxdepth 1 -type f -name '*.html' ! -name 'index.html' \
  -printf '%f\n' | sort | while IFS= read -r file; do
    escaped=${file//&/&amp;}
    escaped=${escaped//</&lt;}
    escaped=${escaped//>/&gt;}
    escaped=${escaped//\"/&quot;}

    printf '      <a href="%s">%s</a>\n' "$escaped" "$escaped" \
      >> "$OUTPUT"
done

cat >> "$OUTPUT" <<'HTML'
    </div>
  </main>
</body>
</html>
HTML

echo "Generated $OUTPUT"
