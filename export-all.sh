#! /bin/zsh
source ~/.zshrc
echo "exporting all versions"

echo "----------------------------------------------------------------"
echo "Releasing Windows"
godot --headless --export-release "Windows" .release/win/MailmanMarty-win.exe
echo "Releasing Linux"
godot --headless --export-release "Linux/X11" .release/linux/MailmanMarty-linux
echo "Releasing Mac"
godot --headless --export-release "macOS" .release/win/MailmanMarty-mac.zip
echo "Releasing Web"
godot --headless --export-release "Web" .release/win/MailmanMarty-web.zip

# butler push .release/win/MailmanMarty-win.exe hayd6262/mailman-marty:windows-release --userversion $1
# butler push .release/linux/MailmanMarty-linux hayd6262/mailman-marty:linux-release --userversion $1
# butler push .release/mac/MailmanMarty-mac.zip hayd6262/mailman-marty:mac-release --userversion $1
# butler push .release/web/MailmanMarty-web.zip hayd6262/mailman-marty:html5-release --userversion $1

