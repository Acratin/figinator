# figinator

## Create ascii art out of text

The figinator is a Mudlet package designed to put the awesome power of [Figlets](http://figlet.org) right at your finger tips.

## Installation

The fastest way to install the figinator is to run the following alias:
`lua uninstallPackage("figinator") installPackage("https://github.com/demonnic/figinator/releases/latest/download/figinator.mpackage")`

## Usage

This is primarily meant to be used via script for your triggers and the like to present big bold text. But I've included a couple of aliases for trying it out.

### Aliases

* `fig fontlist`
  * A list of the fonts included in this package and available for use
* `fig font <fontName>`
  * Select which figlet font to use
* `fig demo <fontName>`
  * Does a demo of the font in regular, kerned, and smushed.
  * also sets future figs to be drawn in this font. It's a side effect of loading the font.
* `fig draw <msg>`
  * Draws `msg` in the currently selected font in the main window
* `fig kern <msg>`
  * Draws `msg` in the currently selected font in the main window with kerning
* `fig smush <msg>`
  * Draws `msg` in the currently selected font in the main window smushed

### API

* `figinator.useFont(fontName)`
  * Tells the figinator to use the specified font for the next figlet.
* `figinator.loadOutsideFont(filename)`
  * Allows you to load arbitrary figlet files not included with the figinator
* `figinator.getString(msg)`
  * Returns `msg` as a figlet in strong format, so you can echo() it where you want Puts space between the letters
* `figinator.getKern(msg)`
  * Like figinator.getString, but with less space between the letters
* `figinator.getSmush(msg)`
  * like figinator.getString, but the letters touch and share edges.
* `figinator.demoFont(font)`
  * Demonstrates the font in all three styles using the msg "Fig Test". This may take a screen to do all three.
* `figinator.demoAll()`
  * Demonstrates all of the fonts. This will be pretty spammy.

## Credit and acclaim

The figlet lua implementation is primarily the work of Nick Gammon and was taken from [his forum](https://www.gammon.com.au/forum/?id=10748&reply=6#reply6) then modified to be a lua module. And I added some convenience methods for getting strings directly instead of a table of lines.

Then I took that and wrapped it in this package which includes several fonts pulled from [this git repo](https://github.com/xero/figlet-fonts) and some convenience methods for switching between the included ones easily.

In short, all the coolest parts of what this does are things other people made, I'm just trying to make them easy for Mudlet users to use =)
