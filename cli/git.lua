local argparse = require('argparse');
local GitRepo = require('git');
local os = require('os');

local parser = argparse("git", "git for OpenComputers")
local checkout = parser:command ("checkout", " Check out a git repo")
checkout:argument("repo", "the repository to checkout eg: 'githubuser/repo'")
checkout:mutex(
    checkout:option('--commit', "specify a commit to checkout"):default(nil),
    checkout:option('--tag', "specify a tag to checkout"):default(nil)
)


local listTags = parser:command ("tags", "List the tags of the repo")
listTags:argument("repo", "the repository  eg: 'githubuser/repo'")

local args = parser:parse({...});


local repo = GitRepo:new(args.repo);

if args.tags == true then
    repo:printTags();
    os.exit(0);
end

if args.checkout == true then
    local dest = nil;
    if args.tag then
        repo:checkoutTag(args.tag, dest);
    elseif args.commit then
        repo:checkout(dest, args.commit);
    else 
        repo:checkout(dest);
    end
    os.exit(0);
end
