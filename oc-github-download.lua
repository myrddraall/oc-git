local shell = require("shell");
local fs = require("filesystem");
local os = require("os");

-- wget -f "https://raw.githubusercontent.com/myrddraall/oc-git/master/oc-github-download.lua" "./oc-github-download.lua"
fs.makeDirectory('/usr/lib');

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-lib/master/lib/json.lua" "/usr/lib/json.lua"');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-import/master/lib/import.lua" "/usr/lib/import.lua"');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-import/master/boot/04_import.lua" "/boot/04_import.lua"');
require("import");


fs.makeDirectory('/usr/lib/oop');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-oop/master/usr/lib/oop/middleclass.lua" "/usr/lib/oop/middleclass.lua"');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-oop/master/usr/lib/oop/Class.lua" "/usr/lib/oop/Class.lua"');

shell.execute('wget -f "https://raw.githubusercontent.com/mpeterv/argparse/0.6.0/src/argparse.lua" "/usr/lib/argparse.lua"');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-git/master/lib/git.lua" "/usr/lib/git.lua"');


package.loaded["git"] = nil;
local GithubRepo = require("git");

print("Installing OC-IMPORT...");
local importGit = GithubRepo:new("myrddraall/oc-import");
importGit:checkout("/tmp/github/repos/oc-import");
shell.execute('cd /tmp/github/repos/oc-import/ && /tmp/github/repos/oc-import/install.lua');

print("Installing OC-OOP...");
local oopGit = GithubRepo:new("myrddraall/oc-oop");
oopGit:checkout("/tmp/github/repos/oc-oop");
shell.execute('cd /tmp/github/repos/oc-oop/ && /tmp/github/repos/oc-oop/install.lua');

print("Installing OC-LIB...");
local libGit = GithubRepo:new("myrddraall/oc-lib");
libGit:checkout("/tmp/github/repos/oc-lib");
shell.execute('cd /tmp/github/repos/oc-lib/ && /tmp/github/repos/oc-lib/install.lua');

print("Installing OC-GIT...");
local githubGit = GithubRepo:new("myrddraall/oc-git");
githubGit:checkout("/tmp/github/repos/oc-git");
shell.execute('cd /tmp/github/repos/oc-git/ && /tmp/github/repos/oc-git/install.lua');

print("Rebooting...")
os.sleep(4);
shell.execute('reboot');

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