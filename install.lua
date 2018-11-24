local shell = require("shell");
shell.execute('rm /usr/lib/git.lua');
shell.execute('cp -r ./lib/* /usr/lib/');