local MockSocket = require 'spec.mock_socket'.MockSocket
local Response = require 'luxure.response'.Response
local utils = require 'luxure.utils'

describe('Response', function()
    it('should send some stuff', function()
        local sock = MockSocket.new()
        local r = Response.new(sock)
        r:send()
        local res = assert(sock.inner[1], 'nothing was sent')
        assert(string.find(res, '^HTTP/1.1 200 OK'), 'Didn\'t contain HTTP preamble')
        assert(string.find(res, 'Server: Luxure'), 'expected server ' .. res)
        assert(string.find(res, 'Content-Length: 0', 0, true), 'expected content length ' .. res)
    end)
    it('should send the right status', function()
        local sock = MockSocket.new()
        local r = Response.new(sock):status(500)
        r:send()
        local res = assert(sock.inner[1], 'nothing was sent')
        assert(string.find(res, '^HTTP/1.1 500 Internal Server Error'), 'expected 500, found ' .. res)
    end)
    it('should send the right default content type/length', function()
        local sock = MockSocket.new()
        local r = Response.new(sock)
        r:send('body')
        local res = assert(sock.inner[1], 'nothing was sent')
        assert(string.find(res, 'Content-Type: text/plain', 0, true), 'expected text/plain ' .. res)
        assert(string.find(res, 'Content-Length: 4', 0, true), 'expected length to be 4 ' .. res)
    end)
    it('should send the right explicit content type', function()
        local sock = MockSocket.new()
        local r = Response.new(sock):content_type('application/json')
        r:send('body')
        local res = assert(sock.inner[1], 'nothing was sent')
        assert(string.find(res, 'Content-Type: application/json', 0, true), 'expected application/json ' .. res)
    end)
end)