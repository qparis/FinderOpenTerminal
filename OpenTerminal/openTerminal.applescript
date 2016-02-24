on run directory
    display dialog "Enter your text here..."
    
    tell application "Terminal"
        activate
        do script "cd " & directory & " && clear || exit"
    end tell
end run