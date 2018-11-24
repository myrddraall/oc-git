local shell = require("shell");
local fs = require("filesystem");
local os = require("os");
print("Downloading...")
shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-lib/master/lib/json.lua" "/usr/lib/json.lua"');

fs.makeDirectory('/usr/lib/oop');
shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-oop/master/lib/middleclass.lua" "/usr/lib/oop/middleclass.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-oop/master/lib/Class.lua" "/usr/lib/oop/Class.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/mpeterv/argparse/0.6.0/src/argparse.lua" "/usr/lib/argparse.lua"');
shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-git/master/lib/git.lua" "usr/lib/git.lua"');


--[[

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
    ]]