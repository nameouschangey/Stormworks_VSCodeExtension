-- by Woe

g_savedata = {}
testOut = ""

function initialize(...) --runs when the world_is_created for the first time.
    -- a great place to build the guts of the g_savedata.
    -- also THE place to get sliders and checkboxes.
    g_savedata = {
        CHECKBOX = property.checkbox("Example Checkbox", true),
        SLIDER = property.slider("Example Slider", -131, 132, 1, 5.0)//1|0
        --default_value should be float. 264 pixels are on the lowest resolution.
    }


    testOut = testOut .. " initialize";
end

function fileLoad(...) --loading from a file, AND not the first load, AND not a ?reload_scripts.
    -- a great place to set previously loaded vehicles and joined players to unloaded and left.
    testOut = testOut .. " fileload";
end

function reload_scripts(...) --happens only when the ?reload_scripts command happens, not a file load, AND not it's first creation.
    -- honestly nothing should be here, but it is a great place to get an alert that the ?reload_scripts happened.
    testOut = testOut .. " reloaded";
end

function onCreate(is_world_create)
    addonName = server.getAddonData((server.getAddonIndex())).name
    if is_world_create then
        initialize(addonName) --g_savedata gets initialized.
    end

    if server.getPlayers()[1].steam_id==0 then
        fileLoad(addonName) --this is when loading from an already saved file AND not a "?reload_scripts".
    else
        reload_scripts(addonName) --NOTE: This is typing the "?reload_scripts" command.
    end
end


