$path = "c:\Users\Admin\OneDrive\Escritorio\Compartidos\software de ruteo\backend\src\main\java\com\ruteo\Main.java"
$content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# 1. Fix BufferedReader leaks
$pattern1 = '(?s)String\s+(\w+)\s*=\s*new BufferedReader\(\s*new InputStreamReader\(exchange\.getRequestBody\(\),\s*StandardCharsets\.UTF_8\)\)\s*\.lines\(\)\.collect\(Collectors\.joining\("\\n"\)\);'
$replacement1 = 'String $1;
                    try (java.io.InputStream is = exchange.getRequestBody()) {
                        $1 = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                    }'
$content = [regex]::Replace($content, $pattern1, $replacement1)

# 2. Fix gson.fromJson Map type safety
$pattern2 = '(?s)gson\.fromJson\(([^,]+),\s*Map\.class\)'
$replacement2 = 'gson.fromJson($1, new com.google.gson.reflect.TypeToken<Map<String, Object>>(){}.getType())'
$content = [regex]::Replace($content, $pattern2, $replacement2)

# 3. Fix gson.fromJson List type safety
$pattern3 = '(?s)gson\.fromJson\(([^,]+),\s*List\.class\)'
$replacement3 = 'gson.fromJson($1, new com.google.gson.reflect.TypeToken<List<Map<String, Object>>>(){}.getType())'
$content = [regex]::Replace($content, $pattern3, $replacement3)

# 4. Remove unused java.time.Duration import
$pattern4 = '(?m)^import\s+java\.time\.Duration;\s*$'
$replacement4 = ''
$content = [regex]::Replace($content, $pattern4, $replacement4)

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Output "Fixed Main.java"
