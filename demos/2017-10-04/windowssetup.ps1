choco install -y visualstudiocode

mkdir "$($env:APPDATA)\Code\User"
cp 'c:\vagrant\vscode.json' `
  "$($env:APPDATA)\Code\User\settings.json"
