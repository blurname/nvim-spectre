local state = require('spectre.state')
local M = {}

M.check_history_update = function (params)
    local type = params.type
    local query = params.query

    local last_type_history_item = state.history[type].stack[state.history[type].index]
    if last_type_history_item == nil then
        table.insert(state.history[type].stack,state.history[type].index+1, query)
    elseif query == last_type_history_item then
        -- do nothing
    else
        for i = state.history[type].index+1, #state.history[type].stack do
            table.remove(state.history[type].stack,state.history[type].index+1)
        end
        table.insert(state.history[type].stack,state.history[type].index+1, query)
    end
    state.history[type].index = #state.history[type].stack
end

M.write_history = function(opts)
    -- search history
    M.check_history_update({type='search',query=opts.search_query})
    -- replace history
    M.check_history_update({type='replace',query=opts.replace_query})
    -- path history
    M.check_history_update({type='path',query=opts.path})
end

return M
