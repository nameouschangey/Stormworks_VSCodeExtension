-- by Woe

--[[
function initialize(...) --runs when the world_is_created for the first time.
    -- a great place to build the guts of the g_savedata.
    -- also THE place to get sliders and checkboxes.
    g_savedata = {
        CHECKBOX = property.checkbox("Example Checkbox", true),
        SLIDER = property.slider("Example Slider", -131, 132, 1, 5.0)//1|0
        --default_value should be float. 264 pixels are on the lowest resolution.
    }
end

function fileLoad(...) --loading from a file, AND not the first load, AND not a ?reload_scripts.
    -- a great place to set previously loaded vehicles and joined players to unloaded and left.
end

function reload_scripts(...) --happens only when the ?reload_scripts command happens, not a file load, AND not it's first creation.
    -- honestly nothing should be here, but it is a great place to get an alert that the ?reload_scripts happened.
    server.announce("Script: " .. addonName, "Reload complete!", 0)
end

-- game's onCreate function
function onCreate(is_world_create)
    addonName = server.getAddonData((server.getAddonIndex())).name
    if is_world_create then
        initialize(addonName) --g_savedata gets initialized.
    else
        if server.getPlayers()[1].steam_id==0 then
            fileLoad(addonName) --this is when loading from an already saved file AND not a "?reload_scripts".
        else
            reload_scripts(addonName) --NOTE: This is typing the "?reload_scripts" command.
        end
    end
end]]

server.announce("LOADED:", g_savedata.testval1)

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, one, two, three, four, five)
    if command == "?set" then
        g_savedata.a = g_savedata.a or {}
        a = g_savedata.a
        a.b = {}
        a.c = a.b
        a.b.e = 123
        a.b.f = 234
    end
    if command == "?test" or command == "?set" then

        server.announce("TEST a: ", g_savedata.a)
        server.announce("TEST a.b: ", g_savedata.a.b)
        server.announce("TEST a.c: ", g_savedata.a.c)
        server.announce("TEST a.b.e: ", g_savedata.a.b.e)
        server.announce("TEST a.b.f: ", g_savedata.a.b.f)
        server.announce("TEST a.c.e: ", g_savedata.a.c.e)
        server.announce("TEST a.c.f: ", g_savedata.a.c.f)
    end
end