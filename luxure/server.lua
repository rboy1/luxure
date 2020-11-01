local Router = require 'luxure.router'.Router
local Request = require 'luxure.request'.Request
local Response = require 'luxure.response'.Response
local methods = require 'luxure.methods'

---@class Server
---@field socket_mod table socket module being used by the server
---@field router Router The router for incoming requests
---@field ip string defaults to '0.0.0.0'
local Server = {}
Server.__index = Server
---Constructor for a Server
---@param socket_mod table This should look something like luasocket
function Server.new(socket_mod)
    local base = {
        socket_mod = socket_mod,
        router = Router.new(),
        ip = '0.0.0.0'
    }
    setmetatable(base, Server)
    return base
end
---Override the default IP address
---@param ip string
function Server:set_ip(ip)
    self.ip = ip
end
---Attempt to open a socket
---@param port number If provided, the port this server will attempt to bind on
function Server:listen(port)
    if port == nil then
        port = 0
    end
    self.sock = self.socket_mod.bind(self.ip, port);
end

for _, method in ipairs(methods) do
    local subbed = string.lower(string.gsub(method, '-', '_'))
    Server[subbed] = function(self, path, callback)
        print('Server:' .. subbed .. ', ' .. path)
        self.router:register_handler(path, method, callback)
    end
end

---A single step in the Server run loop
function Server:tick()
    print('Server:tick')
    local incoming = assert(self.sock:accept())
    local req = Request.new(incoming)
    local res = Response.new(incoming)
    self.router:route(req, res)
end
---Start this server, blocking forever
function Server:run()
    while true do
        local success, msg = pcall(self:tick())
        if not success then
            print(string.format('error in tick: %s', msg))
        end
    end
end

return {
    Server = Server,
}