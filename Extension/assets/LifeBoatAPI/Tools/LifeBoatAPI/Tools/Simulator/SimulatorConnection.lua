-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

local _socket = require("socket")


---@class SimulatorConnection : BaseClass
---@field isAlive boolean whether the connection is current live
---@field client table socket connection
LifeBoatAPI.Tools.SimulatorConnection = {
    ---@return SimulatorConnection
    new = function(this)
        this = LifeBoatAPI.Tools.BaseClass.new(this)

        local host = "127.0.0.1"
        local port = 14238

        this.client = assert(_socket.tcp())
        this.client:connect(host, port)

        this.isAlive = true

        return this
    end;

    ---@param this SimulatorConnection
    close = function (this)
        this:sendCommand("SHUTDOWN", "")
        this.client:close()
    end;

    ---@param this SimulatorConnection
    ---@param commandName string name of the command
    ---@vararg ... additional string params to send to the simulator
    sendCommand = function (this, commandName, ...)

        -- ensure all params are strings
        local params = {...}
        for k,v in pairs(params) do
            params[k] = tostring(v)
        end

        local command = commandName .. "|" .. table.concat(params, "|")

        -- using first 4 characters for length
        local lengthString = string.format("%04d", #command)
        this:sendBytes(lengthString .. command);
    end;

    ---@return boolean messageExists whether a message is ready to be read or not
    hasMessage = function(this)
        return #(_socket.select({this.client}, nil, 0)) > 0
    end;

    ---@return string message reads the next message waiting from the simulator
    readMessage = function(this)
        local size = this:readBytes(4)

        if(size ~= nil and tonumber(size) ~= nil) then
            return this:readBytes(tonumber(size))
        end
        return nil
    end;

    ---@param this SimulatorConnection
    ---@param numBytes number number of bytes to read from the connection
    ---@return string value
    readBytes = function(this, numBytes)
        local bytesRead = 0
        local data = ""
        while bytesRead < numBytes do
            local buffer, err = this.client:receive(numBytes - bytesRead)

            if err == "closed" then
                this.isAlive = false
                return nil
            elseif err then
                error(err)
            end

            bytesRead = bytesRead + #buffer
            data = data .. buffer
        end
        return data
    end;

    sendBytes = function(this, message)
        local length = #message
        local bytesSent = 0
        while bytesSent < length do
            local sent, err = this.client:send(message);

            if err == "closed" then
                this.isAlive = false
                return
            elseif err then
                error(err)
            end

            bytesSent = bytesSent + sent
        end
    end;
}