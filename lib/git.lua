local shell = require("shell");
local internet = require("internet");
local data = require("component").data;
local fs = require("filesystem");
local json = require("json");
local Class = require("oop/Class");
local os = require("os");

local function readHttpResponse(response)
    local result = "";
    local success, chunk = pcall(response);
    if not success then
        error("Error reading: " .. chunk);
    end
    
    while success and chunk ~= nil do
        result = result .. tostring(chunk);
        success, chunk = pcall(response);
        if not success then
            error("Error reading: " .. chunk);
        end
        --os.sleep(0.01);
    end 
    return result;
end

local function getHttpData(url, headers)
    local request, response = pcall(internet.request, url, nil, headers);
    if request then
        return pcall(readHttpResponse, response);
    end
end

local function getHttpJson(url, headers)
    local success, data = getHttpData(url, headers);
    if not success then
        return false, "Error reading: " .. url;
    end
    if data then
        local success, jdata = pcall(json.decode, data);
        if success then
            -- local a = json.encode(jdata, {indent = 2});
            -- print(a);
            return true, jdata;
        else
            return false, "Could not parse json for '" .. url .. "'";
        end
    end
end

local function getGitApiUrl(repo, path, value)
    value = value or "";
    return "https://" .. fs.concat("api.github.com/repos", repo, path, value);
end

local function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function getGitContentUrl(repo, sha, path)
    value = value or "";
    return "https://" .. fs.concat("raw.githubusercontent.com", repo, sha, path);
end


local GithubRepo = Class("GithubRepo");


function GithubRepo:initialize (repo, credentials)
    local parts = split(repo, "/");
    self.url = repo;
    self.userName = parts[1];
    self.repo = parts[2];
    if credentials then
        self.headers =  {
            Authorization = 'Basic ' .. credentials;
        };
    end
end

local API_LIST_REFS = "/git/refs";
local API_LIST_TAGS = "/tags";
local API_COMMITS = "/git/commits/";

function GithubRepo:getRefs()
    return getHttpJson(getGitApiUrl(self.url, API_LIST_REFS), self.headers);
end

function GithubRepo:printRefs(returnString)
    local success, result = self:getRefs();
    if success then
        local str = json.encode(result, {indent = 2});
        if returnString then
            return str;
        end
        print(str);
    end
    return "";
end


function GithubRepo:listTags()
    local success, result = getHttpJson(getGitApiUrl(self.url, API_LIST_TAGS), self.headers);
    if not success then
        error(result);
    end

    local list = {};

    for i, v in ipairs(result) do
        table.insert(list, v.name);
    end

    return list;
end

function GithubRepo:getTags()
    local success, result = getHttpJson(getGitApiUrl(self.url, API_LIST_TAGS), self.headers);
    if not success then
        error(result);
    end
    return result;
end

function GithubRepo:findTag(tag)
    local tags = self:getTags();
    for i, v in ipairs(tags) do
        if v.name == tag then
            return v;
        end
    end
end

function GithubRepo:printTags(full, returnString)
    local str = "";
    if not full then
        for i, v in ipairs(self:listTags()) do
            str = str .. v .. "\n";
        end
    else
        str = json.encode(self:getTags(), {indent = 2});
    end
    if returnString then
        return str;
    end
    print(str);
end


function GithubRepo:checkoutTag(tag, dest)
    local tag = self:findTag(tag);
    print(json.encode(tag, {indent=2}))
    self:_checkout(tag.commit.sha, dest);
end

function GithubRepo:_checkout (sha, dest)
    dest = dest or './' .. self.repo;
    local url = getGitApiUrl(self.url, API_COMMITS, sha);
    local success, result = getHttpJson(url, self.headers);
    if not success then
        error(result);
    end
    local filetree = result.tree;
    local path = shell.resolve(dest);
    fs.makeDirectory(path)
    self:_downloadTree(dest, sha, filetree.url);
end

function GithubRepo:_downloadTree(dest, sha, fileUrl, parentDir)
    parentDir = parentDir or "";
    local success, fileData = getHttpJson(fileUrl, self.headers);

    if not success then
        error(fileData);
    end
    for _, child in pairs(fileData.tree) do
        local filename = fs.concat(parentDir, child.path);
        if child.type == "tree" then
            self:_makeDir(dest, filename);
            self:_downloadTree(dest, sha, child.url, filename);
        else
            
            self:_downloadFile(dest, sha, filename);
        end
    end 
end

function GithubRepo:_makeDir(dest, dir)
    dest = dest or './' .. self.repo;
    local path = shell.resolve(fs.concat(dest, dir));
    print("Creating directory: " .. dir);
    fs.makeDirectory(path);
end

function GithubRepo:_downloadFile(dest, sha, filename)
    dest = dest or './' .. self.repo;
    local path = shell.resolve(fs.concat(dest, filename));
    print("Downloading: " .. filename);
    local fileUrl = getGitContentUrl(self.url, sha, filename);
    local success, data = getHttpData(fileUrl, self.headers);
    if not success then
        error("Error downloading " .. filename);
    end

    local file = fs.open(path, "w");
    file:write(data);
    file:close();
end

function GithubRepo:checkout (dest, sha)
    if sha then
        self:_checkout(sha, dest);
    else
        local success, repoData = self:getRefs();
        if not success then
            print("Error: Could not checkout repo '" .. self.repo .. "''");
            print(repoData);
        else
            local lastest = repoData[1].object;
            local newestSha = lastest.sha;
            self:_checkout(newestSha, dest);
        end
    end
end

return GithubRepo;