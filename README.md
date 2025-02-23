# figinator

## Create ascii art out of text

The figinator is a Mudlet package designed to put the awesome power of [Figlets](http://figlet.org) right at your finger tips.

Examples of all the included fonts can be font on [the Wiki](https://github.com/demonnic/figinator/wiki)

## Installation

The fastest way to install the figinator is to run the following alias:

`lua uninstallPackage("figinator") installPackage("https://github.com/demonnic/figinator/releases/latest/download/figinator.mpackage")`

After that you can stay up to date using the `fig update` alias. (Available in 1.2+)

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
* `fig update`
  * downloads the latest version of the figinator and installs it.

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
* `figinator.getFancy(options)`
  * This function does it all! Including interleaving color gradients for use with decho!
  * options is a table of options to apply. Valid options are:
    * msg
      * this one is required, and is the text to make the figlet out of
    * kern
      * if true, will apply kerning, reducing the space between the letters
      * defaults to false
    * smush
      * if true, will smush the letters closer, having them share edges where possible
      * defaults to false
    * gradType
      * use either 'h' for horizontal, or 'v' for vertical. 
      * defaults to 'h'
    * gradient
      * the actual gradient to use. Can either be a table of gradient stops to use, or the string name of an included gradient
      * `gradient = {{50,50,50}, {255,0,0}, {50,50,50}}`
        * would shift from grey to red to grey
      * `gradient = "rainbow"`
        * will use the included "rainbow" gradient
    * contrastColor
      * What color to contrast the gradient with.
      * defaults to 'black'
      * can use named colors from cecho (such as "black", "white", "magenta"), decho ("<0,0,0>", "<255,255,255>"), or hecho ("#000000", "#FFFFFF")
      * the special color "invert" will cause the contrast color to be the inverse of the gradient color. That is to say, if the gradient for a space has `r,g,b` of `128,255,0` then the contrast will be `127,0,255`. This is done for every space.
    * invert
      * When this is true then the text will be the contrastColor, and the background will be the gradient color. So if you use the rainbow gradient and the default contrastColor of "black" then the background colors will shift through the rainbow, and the text which makes the ascii art will be black.
    * font
      * Select what font you wish this fig to use. Otherwise it will default to basic.  
  * example:
    * `decho(figinator.getFancy({ msg = "Gradient1", gradient = "rainbow", smush = true }))`
      * Uses the included 'rainbow' gradient horizontally
    * `decho(figinator.getFancy({ msg = "Gradient2", gradient = {{255,0,0}, {0,255,0}} }))`
      * Will gradient from red to green horizontally
    * `decho(figinator.getFancy({ msg = "Gradient3", gradType = "v", kern = true, gradient = {{75,0,0}, {255,0,0}} }))`
      * Will gradient from dark red to light red, vertically.
    * `decho(figinator.getFancy({ msg = "NewFont", gradient = "rainbow", font = "smslant"}))`
      * Will change font to smslant for this fig.

## Credit and acclaim

The figlet lua implementation is primarily the work of Nick Gammon and was taken from [his forum](https://www.gammon.com.au/forum/?id=10748&reply=6#reply6) then modified to be a lua module. And I added some convenience methods for getting strings directly instead of a table of lines.

Then I took that and wrapped it in this package which includes several fonts pulled from [this git repo](https://github.com/xero/figlet-fonts) and some convenience methods for switching between the included ones easily.

In short, all the coolest parts of what this does are things other people made, I'm just trying to make them easy for Mudlet users to use =)
