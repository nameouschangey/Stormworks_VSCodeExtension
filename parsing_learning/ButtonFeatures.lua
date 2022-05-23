---@section toggleButtonUI
function toggleButtonUI(btn, text, textColor, outlineColor, fillColor, defaultColor)
    if btn:lbbutton_isClicked() then                                            -- Activates when the button is clicked.
      btn.toggled = not btn.toggled                                             -- Changes btn.toggled to the opposite value.
    end
    if btn.toggled then                                                         -- Activates when btn.toggled is true.
      screen.setColor(hex2rgb(fillColor))                                       -- Sets the filling color
      screen.drawRectF(btn.x, btn.y, btn.width, btn.height)                     -- Fills up a rectangle on the x, y, width and height of the button
      screen.setColor(hex2rgb(textColor))                                       -- Sets the color of the text
      screen.drawTextBox(btn.x+1, btn.y, btn.width+1, btn.height+1, text, 0, 0)   -- Draws a textbox inside the x, y, width and height of the button
      screen.setColor(hex2rgb(outlineColor))                                    -- Sets the color of the outline
      screen.drawRect(btn.x, btn.y, btn.width, btn.height)                      -- Adds a rectangle for the outline on the x, y, width and height of the button
      screen.setColor(hex2rgb(defaultColor))                                    -- Sets the color to the default color.
    else
      screen.setColor(hex2rgb(defaultColor))                                    -- Sets the color to the default color.
      screen.drawRect(btn.x, btn.y, btn.width, btn.height)                      -- Adds a rectangle around the text
      screen.drawTextBox(btn.x+1, btn.y, btn.width+1, btn.height+1, text, 0, 0)   -- Adds a textbox with text inside on the x, y, width and height of the button
    end
  end
---@endsection

---@section toggleButtonClick
  function toggleButtonClick_hold(btn, compOutput)
    if btn:lbbutton_isHeld() then              -- Activates when the button is held.
      btn.toggled = true                       -- Sets the btn.toggled to true so it activates the UI
      output.setBool(compOutput, btn.toggled)  -- Sets the comp output to the btn.toggled value
      return btn.toggled
    else
      btn.toggled = false                      -- Sets the btn.toggled to false so it deactivates the UI
      output.setBool(compOutput, btn.toggled)  -- Sets the comp output to the btn.toggled value
      return btn.toggled
    end
  end
  ---@endsection

  ---@section toggleButtonClick_click
  function toggleButtonClick_click(btn, compOutput)
    if btn:lbbutton_isClicked() then
      output.setBool(compOutput, true)
      return true
    else
      output.setBool(compOutput, false)
      return false
    end
  end
  ---@endsection

  ---@section toggleButtonClick_toggle
  function toggleButtonClick_toggle(btn, compOutput)
    if btn:lbbutton_isClicked() then           -- Activates when the button is clicked.
      btn.clicked = not btn.clicked            -- Sets the btn.clicked to the opposite of the value it had.
      output.setBool(compOutput, btn.clicked)  -- Sets the comp output to the btn.clicked value.
      return btn.clicked
    end
  end
  ---@endsection

  ---@section hex2rgb
  function hex2rgb(hex)
      hex = hex:gsub("#","")  -- Removes the # if it had one.
      return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))  -- Returns the hex in 3 different values as R, G and B
  end
  ---@endsection