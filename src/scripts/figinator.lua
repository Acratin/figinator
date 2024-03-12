figinator = figinator or {}
figinator.grads = {
  rainbow = { { 255, 0, 0 }, { 255, 128, 0 }, { 255, 255, 0 }, { 0, 255, 0 }, { 0, 255, 255 }, { 0, 128, 255 }, { 128, 0, 255 } },
  green = {{50,50,50}, {0,255,0}, {50,50,50}},
  red = {{50,50,50}, {255,0,0}, {50,50,50}},
  blue = {{50,50,50}, {0,0,255}, {50,50,50}},
  redblue = {{255, 0, 0}, {0, 0, 255}},
  redbluered = {{255, 0, 0}, {0, 0, 255}, {255, 0,0}},
  redbluegreen = {{255, 0, 0}, {0, 0, 255}, {0,255,0}},
  redgreen = {{255, 0,0}, {0,255,0}},
  redgreenred = {{255, 0,0}, {0,255,0}, {255,0,0}},
  redgreenblue = {{255, 0,0}, {0,255,0}, {0,0,255}},
  bluered = {{0,0,255}, {255, 0, 0}},
  blueredblue = {{0,0,255}, {255, 0, 0}, {0,0,255}},
  blueredgreen = {{0,0,255}, {255, 0, 0}, {0,255,0}},
  bluegreen = {{0,0,255}, {0,255,0}},
  bluegreenblue = {{0,0,255}, {0,255,0}, {0,0,255}},
  bluegreenred = {{0,0,255}, {0,255,0}, {255,0,0}},
  greenred = {{0,255,0}, {255,0,0}},
  greenredgreen = {{0,255,0}, {255,0,0}, {0,255,0}},
  greenredblue = {{0,255,0}, {255,0,0}, {0,0,255}},
  greenblue = {{0,255,0}, {0,0,255}},
  greenbluegreen = {{0,255,0}, {0,0,255}, {0,255,0}},
  greenbluered = {{0,255,0}, {0,0,255}, {255,0,0}},
}

-- setup some basic variables for use
local dir = getMudletHomeDir() .. "/@PKGNAME@/"
local fonts = {
  ["acrobatic"] = true,
  ["alligator"] = true,
  ["alligator2"] = true,
  ["banner"] = true,
  ["banner3"] = true,
  ["barbwire"] = true,
  ["basic"] = true,
  ["big"] = true,
  ["broadway"] = true,
  ["caligraphy"] = true,
  ["fraktur"] = true,
  ["gothic"] = true,
  ["gradient"] = true,
  ["ogre"] = true,
  ["slant"] = true,
  ["smslant"] = true,
  ["cosmic"] = true,
  ["sblood"] = true,
  ["dosrebel"] = true,
  ["3x5"] = true,
}
local fontNames = table.keys(fonts)
table.sort(fontNames)

-- instantiate the figlet instance, or reuse the existing one
local fig = figinator.fig or require("@PKGNAME@.figlet")
figinator.fig = fig

local gm = figinator.gm or require("@PKGNAME@.gradientmaker")
figinator.gm = gm

-- to echo stuff
local function fecho(msg)
  cecho(f"<purple>FIGINATOR<reset>: {msg}\n")
end
figinator.fecho = fecho

function figinator.getString(msg)
  return fig.getString(msg)
end

function figinator.getKern(msg)
  return fig.getKern(msg)
end

function figinator.getSmush(msg)
  return fig.getSmush(msg)
end

function figinator.getFancy(options)
  local sub = string.sub
  local functionSig = "figinator.getFancy(options):"
  local optionsType = type(options)
  if optionsType ~= "table" then
    return nil, f"{functionSig} options must be a table of options, got {optionsType}"
  end
  if not options.msg then
    return nil, f"{functionSig} options must contain a 'msg' key, in order to create the figlet"
  end
  local figTable = fig.ascii_art(options.msg, options.kern, options.smush)
  local gradient = options.gradient
  if type(gradient) == "string" then
    gradient = figinator.grads[gradient]
  end
  local gradientType = type(gradient)
  if gradientType ~= "table" then
    local gradKeys = table.keys(figinator.grads)
    printDebug(f"{functionSig} options.gradient must either be a table of gradient stops, such as {{255,0,0},{0,255,0}} , or the name of an included gradient. Ignoring gradient. Valid gradients include: {table.concat(gradKeys, ', ')}", true)
    gradient = nil
  end
  if not gradient then
    return table.concat(figTable, "\n")
  end

  options.gradType = options.gradType or "h"
  local gradType
  if not (options.gradType:starts("h") or options.gradType:starts("v")) then
    printDebug(f"{functionSig} options.gradType must begin with 'h' for horizontal gradient, or 'v' for vertical gradient. You passed {options.gradType} which is unknown. Defaulting to 'h' for horizontal", true)
    gradType = "h"
  else
    gradType = options.gradType
  end
  local fontChoice = options.font or "basic"
  local fontName = fontChoice
  local ok,err = figinator.useFont(fontName)
  if not ok then
    figinator.fecho(err)
    return
  end
  local contrastColor = options.contrastColor or "black"
  local br,bg,bb,contrast
  if contrastColor ~= "invert" then
    br,bg,bb = Geyser.Color.parse(contrastColor)
    contrast = string.format("%d,%d,%d", br, bg, bb)
  end
  if gradType:starts("h") then
    local length = 0
    for _, line in ipairs(figTable) do
      local len = #line
      if len > length then length = len end
    end
    local colors = gm.just_colors(length, unpack(gradient))
    local result = ""
    for _, line in ipairs(figTable) do
      for i=1,#line do
        local r,g,b = unpack(colors[i])
        local template
        if contrastColor == "invert" then
          br,bb,bg = (255-r), (255-b), (255-g)
          contrast = string.format("%d,%d,%d", br, bg, bb)
        end
        if options.invert then
          template = "%s<" .. contrast .. ":%d,%d,%d>%s"
        else
          template = "%s<%d,%d,%d:" .. contrast .. ">%s"
        end
        result = string.format(template, result, r, g, b, sub(line, i, i))
      end
      result = result .. "\n"
    end
    return result
  end
  local length = #figTable
  local colors = gm.just_colors(length, unpack(gradient))
  local result = ""
  for i, line in ipairs(figTable) do
    local r,g,b = unpack(colors[i])
    local template
    if contrastColor == "invert" then
      br,bb,bg = (255-r), (255-b), (255-g)
      contrast = string.format("%d,%d,%d", br, bg, bb)
    end
    if options.invert then
      template = "%s<" .. contrast .. ":%d,%d,%d>%s\n"
    else
      template = "%s<%d,%d,%d:" .. contrast .. ">%s\n"
    end
    result = string.format(template, result, r, g, b, line)
  end
  return result
end

function figinator.useFont(font)
  font = string.lower(font)
  local dir = dir
  if not fonts[font] then
    local msg = "We do not know about this font. Valid fonts are: " .. table.concat(fontNames, ", ")
    return nil, msg
  end
  local filename = f"{dir}{font:title()}.flf"
  fig.readfont(filename)
  return true
end

function figinator.loadOutsideFont(filename)
  fig.readfont(filename)
end

function figinator.demoFont(font)
  local ok,err = figinator.useFont(font)
  if not ok then
    return ok, err
  end
  fecho("figinator.getString('Fig Test')\n")
  echo(fig.getString("Fig Test").. "\n\n")
  fecho("figinator.getKern('Fig Test')\n")
  echo(fig.getKern("Fig Test").. "\n\n")
  fecho("figinator.getSmush('Fig Test')\n")
  echo(fig.getSmush("Fig Test").. "\n\n")
  return true
end

function figinator.listFonts()
  fecho("List of available fonts:")
  for _,name in ipairs(fontNames) do
    fecho(name)
  end
end

function figinator.demoAll()
  for _, font in ipairs(fontNames) do
    fecho("Demo for: " .. font)
    figinator.demoFont(font)
  end
end

if table.is_empty(fig.loadedFonts) then
  figinator.useFont('basic')
end
