local Route = require 'luxure.route'.Route
local utils = require 'luxure.utils'
local net_url = require 'net.url'

describe('Route', function()
    it('matches parameterized paths', function()
        local r = Route.new('/a/:b')
        assert(r:matches(net_url.parse('/a/1')), 'expected a match ' .. utils.table_string(r))
    end)
    it('matches plain paths', function()
        local r = Route.new('/a/b')
        assert(r:matches(net_url.parse('/a/b')), 'expected a match ' .. utils.table_string(r))
    end)
    it('matches paths with queries', function()
        local r = Route.new('/a/b')
        assert(r:matches(net_url.parse('/a/b?c=d&e=f')), 'expected a match ' .. utils.table_string(r))
    end)
    it('parses colon parameters correctly', function()
        local r = Route.new('/a/:b')
        local matches, params = r:matches(net_url.parse('a/1'))
        assert(matches, 'expected a match: ' .. utils.table_string(r))
        assert(params.b == '1', 'b == 1 ' .. utils.table_string(params))
    end)
end)