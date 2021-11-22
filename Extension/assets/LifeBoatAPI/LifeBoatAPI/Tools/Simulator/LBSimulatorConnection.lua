_socket = require("socket")

---@class LBSimulatorConnection : LBBaseClass
---@field isAlive boolean whether the connection is current live
---@field client table socket connection
LBSimulatorConnection = {
    ---@return LBSimulatorConnection
    new = function(this)
        this = LBBaseClass.new(this)

        local host = "127.0.0.1"
        local port = 14238

        this.client = assert(_socket.tcp())
        this.client:connect(host, port)

        this.isAlive = true

        return this
    end;

    ---@param this LBSimulatorConnection
    close = function (this)
        this:sendCommand("SHUTDOWN", "")
        this.client:close()
    end;

    ---@param this LBSimulatorConnection
    ---@param commandName string name of the command
    ---@vararg ... additional string params to send to the simulator
    sendCommand = function (this, commandName, ...)
        local command = commandName .. "|" .. table.concat({...}, "|")

        -- using first 4 characters for length
        local lengthString = string.format("%04d", #command + 1)
        local bytesSend, err = this.client:send(lengthString .. command .. "\n");

        if err == "closed" then
            this.isAlive = false
        elseif err then
            error(err)
        end
    end;

    ---@return boolean messageExists whether a message is ready to be read or not
    hasMessage = function(this)
        return #(_socket.select({this.client}, nil, 0)) > 0
    end;

    ---@return string message reads the next message waiting from the simulator
    readMessage = function(this)
        local size, err = this.client:receive(4)

        if err == "closed" then
            this.isAlive = false
            return nil
        elseif err then
            error(err)
        end

        size = tonumber(size)
        local bytesRead = 0
        local data = ""
        while bytesRead < size do
            local buffer, err = this.client:receive(size - bytesRead)
            bytesRead = bytesRead + #buffer
            data = data .. buffer

            if err == "closed" then
                this.isAlive = false
                return nil
            elseif err then
                error(err)
            end
        end
        return data
    end;    
}