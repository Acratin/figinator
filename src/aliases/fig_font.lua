local fontName = matches[2]
local ok,err = figinator.useFont(fontName)
if not ok then
  figinator.fecho(err)
  return
end
figinator.fecho("Now using " .. fontName)