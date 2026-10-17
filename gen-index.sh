
#!/usr/bin/env bash
set -euo pipefail

OUTPUT="index.html"

# Generate index.html
{
  cat <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My HTML Apps</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f3f4f6;
           margin: 0; padding: 30px 16px; color: #1f2937; }
    main { max-width: 700px; margin: auto; }
    h1 { text-align: center; }
    .apps { display: grid; gap: 12px; margin-top: 28px; }
    .apps a { display: block; padding: 18px; background: white;
              border-radius: 12px; text-decoration: none;
              color: #2563eb; font-weight: bold; overflow-wrap: anywhere; }
    .apps a:hover { background: #dbeafe; }
  </style>
</head>
<body>
  <main>
    <h1>My HTML Apps</h1>
    <p>Select an application to open.</p>
    <div class="apps">
HTML

  find . -maxdepth 1 -type f -name '*.html' ! -name "$OUTPUT" \
    -printf '%f\n' | sort | while IFS= read -r file; do
      printf '      <a href="%s">%s</a>\n' "$file" "$file"
    done

  cat <<'HTML'
    </div>
  </main>
</body>
</html>
HTML
} > "$OUTPUT"

echo "Generated $OUTPUT"

# Stage HTML files
git add -- '*.html'

# Skip commit if nothing changed
if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

# Commit message: date + changed filenames
DATE=$(date '+%Y-%m-%d %H:%M:%S')
FILES=$(git diff --cached --name-only | paste -sd ', ' -)
MSG="$DATE - $FILES"

git commit -m "$MSG"

# Push to current branch
git push

echo "Done! Changes pushed to GitHub."
