
local mod_name = "__Ingredient_Scrap__"

local yutil = { table={} }

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
    if type(_t[2]) ~= "number" then --[[log(" Warning: add_pairs("..type(_t[1])..", "..type(_t[2])..") - implicitly set value - amount = 1");]] _t[2] = 1 end
    return { name = _t[1], amount = _t[2] or 1}
  elseif type(_t) == "string" then
    log(" Warning: add_pairs("..type(_t[1])..", "..type(_t[2])..") - implicitly set value - amount = 1")
    return { name = _t, amount = 1}
  end
  return _t
end
-- log(serpent.block( add_pairs({ "iron-gear-wheel", 10 }) ))
-- log(serpent.block( add_pairs({ "copper-plate", 10 }) ))
-- log(serpent.block( add_pairs({ name="iron-plate", amount=20 }) ))
-- log(serpent.block( add_pairs({ name = "uranium-235", probability = 0.007, amount = 1 }) ))
-- assert(1==2, "add_pairs()")



----------------
--    ICONS   --
----------------



---returns an icon in the form of ``path/color-scrap-index.png``
---@param color string
---@param index number
---@return string
function yutil.get_icon_bycolor(color, index)
  local icon_path = mod_name.. "/graphics/icons/color/"
  local icon  	  = nil
  local missing   = mod_name.. "/graphics/icons/missing-icon.png"
  local recycle   = mod_name.. "/graphics/icons/recycle.png"
  local icons = {
    blue    = "blue",
    brown   = "brown",
    dgrey   = "darkgrey",
    grey    = "grey",
    orange  = "orange",
    purple  = "purple",
    red     = "red",
    teal    = "teal",
    yellow  = "yellow",
  }

  if type(color) == "string" and icons[color] then
    if type(index) =="number" then
      index = tostring(util.clamp(index, 1, 3))
      icon = icon_path..icons[color].."-scrap-"..index..".png"
    else
      icon = icon_path..icons[color].."-scrap-"..tostring(math.random(3))..".png"
    end
  elseif color == "recycle" then
    icon = recycle
  end

  return icon or missing
end


---@return string
function yutil.get_item_icon(scrap_type)
  local icon_path = mod_name.. "/graphics/icons/"
  local icon = icon_path..scrap_type.."-scrap.png"
  local icons = {
    missing   = icon_path.."missing-icon.png",
    recycle   = icon_path.."recycle.png",
    iron      = icon,
    copper    = icon,
    steel     = icon,
    imersium      = yutil.get_icon_bycolor("purple", 1),
    lead          = yutil.get_icon_bycolor("brown", 3),
    titanium      = yutil.get_icon_bycolor("dgrey", 2),
    zinc          = yutil.get_icon_bycolor("grey", 2),
    nickel        = yutil.get_icon_bycolor("grey", 2),
    aluminium     = yutil.get_icon_bycolor("grey", 1),
    tungsten      = yutil.get_icon_bycolor("dgrey", 1),
    tin           = yutil.get_icon_bycolor("grey", 2),
    silver        = yutil.get_icon_bycolor("grey", 1),
    gold          = yutil.get_icon_bycolor("yellow", 2),
    brass         = yutil.get_icon_bycolor("yellow", 1),
    bronze        = yutil.get_icon_bycolor("yellow", 2),
    nitinol       = yutil.get_icon_bycolor("grey", 2),
    invar         = yutil.get_icon_bycolor("grey", 3),
    cobalt        = yutil.get_icon_bycolor("blue", 2),
    -- glass      = yutil.get_icon_bycolor("purple", 1),
    -- silicon    = yutil.get_icon_bycolor("purple", 1),
    gunmetal      = yutil.get_icon_bycolor("yellow", 2),
    lithium       = yutil.get_icon_bycolor("dgrey", 1),
    ["cobalt-steel"]  = yutil.get_icon_bycolor("blue", 1),
    ["copper-tungsten"]  = yutil.get_icon_bycolor("red", 2),
    chromium      = yutil.get_icon_bycolor("grey", 1),
    tellurium     = yutil.get_icon_bycolor("purple", 1),
    adamantite    = yutil.get_icon_bycolor("purple", 1),
    antitate      = yutil.get_icon_bycolor("red", 1),
    ["pro-galena"]= yutil.get_icon_bycolor("dgrey", 1),
    orichalcite   = yutil.get_icon_bycolor("orange", 1),
    phosphorite   = yutil.get_icon_bycolor("grey", 1),
    sanguinate    = yutil.get_icon_bycolor("red", 1),
    elionagate    = yutil.get_icon_bycolor("teal", 1),
    ["meta-garnierite"] = yutil.get_icon_bycolor("yellow", 1),
    ["nova-leucoxene"] = yutil.get_icon_bycolor("dgrey", 1),
    stannic = yutil.get_icon_bycolor("green", 3),
    plumbic = yutil.get_icon_bycolor("purple", 3),
    manganic = yutil.get_icon_bycolor("orange", 3),
    titanic = yutil.get_icon_bycolor("grey", 3),
    phosphic = yutil.get_icon_bycolor("teal", 3),
  }
  return icons[scrap_type] or icons.missing
end

function yutil.get_recycle_icons(scrap_type, result_name)
  local icon_item, icon_size, icon_mipmaps, scale_factor

  if data.raw.item[result_name] then
    if data.raw.item[result_name].icon then
      icon_item = data.raw.item[result_name].icon
      icon_size = data.raw.item[result_name].icon_size
      icon_mipmaps = data.raw.item[result_name].icon_mipmaps
    elseif data.raw.item[scrap_type].icon then
      icon_item = data.raw.item[scrap_type].icon
      icon_size = data.raw.item[scrap_type].icon_size
      icon_mipmaps = data.raw.item[scrap_type].icon_mipmaps
    end
  end
  scale_factor = (64/icon_size) or 1
  return {
    {
      icon = yutil.get_item_icon(scrap_type),
      icon_size = 64, icon_mipmaps = 4,
      scale = 0.5, shift = util.by_pixel(0, 0)
    },
    {
      icon = icon_item or yutil.get_item_icon("missing"),
      icon_size = icon_size or 64, icon_mipmaps = icon_mipmaps or 4,
      scale = 0.25*scale_factor, shift = {-8,-8}
    },
    {
      icon = yutil.get_item_icon("recycle"),
      icon_size = 64, icon_mipmaps = 4,
      scale = 0.5, shift = util.by_pixel(0, 0), tint = { r = 0.8, g = 1.0, b = 0.8, a = 1.0 }
    },
  }
end


return yutil
