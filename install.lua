local shell = require("shell");
local fs = require("filesystem");
print("Downloading JSON lib...")
shell.execute('wget -fq "https://raw.githubusercontent.com/rater193/OpenComputers-1.7.10-Base-Monitor/master/lib/json.lua" "/lib/json.lua"');

print("Downloading OOP lib...")
fs.makeDirectory('/lib/soul');
shell.execute('wget -fq "https://raw.githubusercontent.com/majesty2450/OpenComputers-SOUL/0.3.1/Mixin.lua" "/lib/soul/Mixin.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/majesty2450/OpenComputers-SOUL/0.3.1/Class.lua" "/lib/soul/Class.lua"');


