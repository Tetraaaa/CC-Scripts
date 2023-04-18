function printLetterByLetter(word)
    local i = 1
    while i < word:len() + 1 do
        term.write(string.sub(word, i, i))
        os.sleep(0.1)
        i = i + 1
    end
end

local sentences = {"Commencing System Check", "Memory Unit: Green", "Initializing Tactics Log",
                   "Loading Geographic Data", "Vitals: Green", "Remaining MP: 100%", "Black Box Temperature: Normal",
                   "Black Box Internal Pressure: Normal", "Activating IFF", "Activating FCS",
                   "Initializing Pod Connection", "Launching DBU Setup", "Activating Inertia Control System", "Activating Environmental Sensors", "Equipment Authentication: Complete", "Equipment Status: Green", "All Systems Green", "Combat Preparations Complete_"}
local monitor = peripheral.wrap("back");
term.redirect(monitor);
monitor.setTextScale(0.5);
term.setBackgroundColor(colors.white);
term.setTextColor(colors.black);
while true
do
    term.clear();
    term.setCursorPos(1, 1)
    for i = 1, #sentences do
        printLetterByLetter(sentences[i])
        term.setCursorPos(1, i + 1)
    end
    term.setCursorBlink(true)
    sleep(3)
end
