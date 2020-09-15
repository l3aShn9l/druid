local M = {}


local function create_infinity_instance(self, record, index)
    local instance = gui.clone_tree(self.infinity_prefab)
    gui.set_enabled(instance["infinity_prefab"], true)
    gui.set_text(instance["infinity_text"], "Infinity record " .. index)

    local button = self.druid:new_button(instance["infinity_prefab"], function()
        print("Infinity click on", index)
    end)

    return instance["infinity_prefab"], button
end



local function setup_infinity_list(self)
    local data = {}
    for i = 1, 2500 do
        table.insert(data, i)
    end

    self.infinity_list = self.druid:new_infinity_list(data, self.infinity_scroll, self.infinity_grid, function(record, index)
        -- function should return gui_node, [druid_component]
        return create_infinity_instance(self, record, index)
    end)

    -- scroll to some index
    local pos = self.infinity_grid:get_pos(950)
    self.infinity_scroll:scroll_to(pos, true)
end


function M.setup_page(self)
    self.infinity_scroll = self.druid:new_scroll("infinity_scroll_stencil", "infinity_scroll_content")
    self.infinity_grid = self.druid:new_grid("infinity_scroll_content", "infinity_prefab", 1)
    self.infinity_grid:set_offset(vmath.vector3(0, 8, 0))

    self.infinity_prefab = gui.get_node("infinity_prefab")
    gui.set_enabled(self.infinity_prefab, false)

    setup_infinity_list(self)
end


return M
