import subprocess

try:
    result = subprocess.run(['git', 'show', 'HEAD:index.html'], capture_output=True, text=True, check=True)
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(result.stdout)
    print("Restored index.html successfully")
except Exception as e:
    print(f"Error: {e}")
