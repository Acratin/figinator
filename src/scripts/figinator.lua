figinator = figinator or {}

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