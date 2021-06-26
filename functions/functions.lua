
local mod_name = "__Ingredient_Scrap__"

yutil = { table={} }

function yutil.table.extend(t1, t2)
  if type(t1) == "table" and type(t2) == "table" then
    for i = 1, #t2 do t1[#t1+1] = t2[i] end return t1 end
end

---adds name and amount keys to ingredients and returns a new table
---@param _table table ``{string, number?}``
---@return table ``{ name = "name", amount = n }``
function yutil.add_pairs(_table)
  local _t = _table
  if type(_t) == "table" and _t[1] then --they can be empty and would be "valid" until ...
    if _t.name then return _t end       --ignore if it has pairs already
    if type(_t[1]) ~= "string" then error(" First index must be of type 'string'") end
    if type(_t[2]) ~= "number" then _t[2] = 1;  log(" Warning: add_pairs("..type(_t[1])..", "..type(_t[2])..") - implicitly set value - amount = 1") end
    if not data.raw.item[_t[1]].type == "item" then log(" Warning: add_pairs() - ".._t[1].." - wrong item type") end
    return { type = "item", name = _t[1], amount = _t[2] or 1}
  elseif type(_t) == "string" then
    log(" Warning: add_pairs("..type(_t[1])..", "..type(_t[2])..") - implicitly set value - amount = 1")
    return { type = "item", name = _t, amount = 1}
  end
  return _t
end
-- log(serpent.block( add_pairs({ "iron-gear-wheel", 10 }) ))
-- log(serpent.block( add_pairs({ "copper-plate", 10 }) ))
-- log(serpent.block( add_pairs({ name="iron-plate", amount=20 }) ))
-- log(serpent.block( add_pairs({ name = "uranium-235", probability = 0.007, amount = 1 }) ))
-- assert(1==2, "add_pairs()")


-- constants = constants or {}
-- constants.difficulty = {
--   ["none"] = 1,
--   ["result"] = 1,
--   ["results"] = 2,
--   ["ingredients"] = 2,
--   ["normal"] = 3,
--   ["expensive"] = 4,
-- }

---comment
---@return string
function yutil.get_icon(name)
  local icon_path = mod_name.. "/graphics/icons/"
  local icon = icon_path..name.."-scrap.png"
  local icons = {
    missing   = icon_path.."missing-icon.png",
    recycle   = icon_path.."recycle.png",
    iron      = icon,
    copper    = icon,
    steel     = icon,
    imersium      = yutil.get_icon_bycolor("purple", 1),
    lead          = yutil.get_icon_bycolor("brown", 3),
    titanium      = yutil.get_icon_bycolor("dgrey", 2),
    zinc          = yutil.get_icon_bycolor("grey", 3),
    nickel        = yutil.get_icon_bycolor("grey", 2),
    aluminium     = yutil.get_icon_bycolor("grey", 1),
    tungsten      = yutil.get_icon_bycolor("grey", 2),
    tin           = yutil.get_icon_bycolor("grey", 2),
    silver        = yutil.get_icon_bycolor("grey", 1),
    gold          = yutil.get_icon_bycolor("yellow", 2),
    brass         = yutil.get_icon_bycolor("yellow", 1),
    bronze        = yutil.get_icon_bycolor("orange", 1),
    nitinol       = yutil.get_icon_bycolor("grey", 2),
    invar         = yutil.get_icon_bycolor("grey", 3),
    cobalt        = yutil.get_icon_bycolor("blue", 2),
    -- glass      = yutil.get_icon_bycolor("purple", 1),
    -- silicon    = yutil.get_icon_bycolor("purple", 1),
    gunmetal      = yutil.get_icon_bycolor("yellow", 1),
    ["cobalt-steel"]  = yutil.get_icon_bycolor("blue", 2),
    ["copper-tungsten"]  = yutil.get_icon_bycolor("red", 2),
  }
  return icons[name] or icons.missing
end

function yutil.get_scrap_icons(item, result)
  local icon_item, icon_size, icon_mipmaps
  if data.raw.item[result] then
    if data.raw.item[result].icon then
      icon_item = data.raw.item[result].icon
      icon_size = data.raw.item[result].icon_size
      icon_mipmaps = data.raw.item[result].icon_mipmaps
    elseif data.raw.item[item].icon then
      icon_item = data.raw.item[item].icon
      icon_size = data.raw.item[item].icon_size
      icon_mipmaps = data.raw.item[item].icon_mipmaps
    end
  end
  return {
    {
      icon = yutil.get_icon(item),
      icon_size = 64, icon_mipmaps = 4,
      scale = 0.5, shift = yutil.by_pixel(0, 0), tint = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
    },
    {
      icon = icon_item or yutil.get_icon("missing"),
      icon_size = icon_size or 64, icon_mipmaps = icon_mipmaps or 4,
      scale = 0.25, shift = yutil.by_pixel(0, 0), tint = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
    },
    {
      icon = yutil.get_icon("recycle"),
      icon_size = 64, icon_mipmaps = 4,
      scale = 0.5, shift = yutil.by_pixel(0, 0), tint = { r = 0.8, g = 1.0, b = 0.8, a = 1.0 }
    },
  }
end


---returns an icon in the form of ``path/color-scrap-index.png``
---@param color string
---@param index number
---@return string
function yutil.get_icon_bycolor(color, index)
  local mod_name = "__Ingredient_Scrap__"
  local icon_path = mod_name.. "/graphics/icons/color/"
  local icon  	  = nil
  local missing   = mod_name.. "/graphics/icons/missing-icon.png"
  local recycle   = mod_name.. "/graphics/icons/recycle.png"
  local icons = {
    blue    = {"blue"},
    brown   = {"brown"},
    dgrey   = {"dgrey"},
    grey    = {"grey"},
    orange  = {"orange"},
    purple  = {"purple"},
    red     = {"red"},
    teal    = {"teal"},
    yellow  = {"yellow"},
  }

  if icons.color then
    if index and type(index) =="number" then
      icon = icon_path..icons.color.."-scrap-"..tostring(yutil.clamp(index, 1, 3))..".png"
    else
      icon = icon_path..icons.color.."-scrap-"..tostring(math.random(3))..".png"
    end
  elseif color == "recycle" then
    icon = recycle
  end


  return icon or missing
end

return yutil
