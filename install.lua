local shell = require("shell");
local fs = require("filesystem");
local os = require("os");
print("Downloading...")
shell.execute('wget -fq "https://raw.githubusercontent.com/rater193/OpenComputers-1.7.10-Base-Monitor/master/lib/json.lua" "/lib/json.lua"');

fs.makeDirectory('/lib/soul');
shell.execute('wget -fq "https://raw.githubusercontent.com/majesty2450/OpenComputers-SOUL/0.3.1/Mixin.lua" "/lib/soul/Mixin.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/majesty2450/OpenComputers-SOUL/0.3.1/Class.lua" "/lib/soul/Class.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/mpeterv/argparse/0.6.0/src/argparse.lua" "/lib/argparse.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-git/stable/lib/git.lua" "/lib/git.lua"');


local GitRepo = require("git");
local oopGit = GitRepo:new("majesty2450/OpenComputers-SOUL");
oopGit:checkout("/lib/soul");

local gitGit = GitRepo:new("myrddraall/oc-git");
gitGit:checkoutTag("stable", "/tmp/git-install/git");

print("Installing...");

shell.execute("cp /tmp/git-install/git/cli/git.lua /bin/");

print("Rebooting...")
os.sleep(2);
shell.execute('reboot');