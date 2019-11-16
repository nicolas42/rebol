; NULLsoft Scriptable Install System
; make a REBOL Script executable
; provided by www.digicamsoft.com
 
; Name of the installer (don't really care here because of silent below)
Name "Namexif"
 
; Don't want a window, just unpack files and execute
SilentInstall silent
 
; Set a name for the resulting executable
OutFile "cellular-automaton.exe"
 
; Set an icon (optional)
 Icon "cell.ico"
 
; The stuff to install
Section ""
  ; Set output path to a temporary directory.
  InitPluginsDir
  SetOutPath $PLUGINSDIR
 
  ; put here requiered files
  File "C:\Users\Nicolas\Downloads\Rebol\rebol.exe" ; a REBOL interpreter
  File "cellular-automaton.r"   ; put one or more REBOL script(s)
  File "cellular-automaton.dll" 
  File "library-utils.r" 
 
  ; Execute and wait for the REBOL script to end
  ExecWait '"$PLUGINSDIR\rebol.exe" "-s" "$PLUGINSDIR\cellular-automaton.r"'
 
  ; Set working directory to something else
  ; If it's not set, $PLUGINSDIR will not be deleted
  SetOutPath $TEMP
SectionEnd
