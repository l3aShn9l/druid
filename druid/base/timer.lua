--- Component to handle GUI timers
-- @module base.timer

local data = require("druid.data")
local formats = require("druid.helper.formats")
local helper = require("druid.helper")

local M = {}
M.interest = {
	data.ON_UPDATE
}

local empty = function() end


function M.init(self, node, seconds_from, seconds_to, callback)
	self.node = helper.get_node(node)
	seconds_from = math.max(seconds_from, 0)
	seconds_to = math.max(seconds_to or 0, 0)
	callback = callback or empty

	self:set_to(seconds_from)
	self:set_interval(seconds_from, seconds_to)
	self.callback = callback

	if seconds_to - seconds_from == 0 then
		self:set_state(false)
		self.callback(self.parent.parent, self)
	end
	return self
end


--- Set text to text field
-- @param set_to - set value in seconds
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, formats.second_string_min(set_to))
end


--- Called when update
-- @param is_on - boolean is timer on
function M.set_state(self, is_on)
	self.is_on = is_on
end


--- Set time interval
-- @param from - "from" time in seconds
-- @param to - "to" time in seconds
function M.set_interval(self, from, to)
	self.from = from
	self.value = from
	self.temp = 0
	self.target = to
	M.set_state(self, true)
	M.set_to(self, from)
end


--- Called when update
-- @param dt - delta time
function M.update(self, dt)
	if self.is_on then
		self.temp = self.temp + dt
		local dist = math.min(1, math.abs(self.value - self.target))

		if self.temp > dist then
			self.temp = self.temp - dist
			self.value = helper.step(self.value, self.target, 1)
			M.set_to(self, self.value)
			if self.value == self.target then
				self:set_state(false)
				self.callback(self.parent.parent, self)
			end
		end
	end
end


return M