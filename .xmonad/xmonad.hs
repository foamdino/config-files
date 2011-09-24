import XMonad
import IO (Handle, hPutStrLn)
-- utils
import XMonad.Util.Run (spawnPipe)
-- hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
-- layouts
import XMonad.Layout.NoBorders

---------------------------------------------------------------------
-- Variables --
myNormalBGColor = "#2e3436"
myFocusedBGColor = "#414141"
myNormalFGColor = "#E0FFFF"
myFocusedFGColor = "#1994d1"
myUrgentFGColor = "#f57900"
myUrgentBGColor = "#2e3436"
mySeperatorColor = "#2e3436"
myVisibleBGColor = "#515151"


xmonadDir = "/home/kevj/.xmonad"
--main = xmonad =<< dzen defaultConfig

main = do
        dzen <- spawnPipe myStatusBar
        conkyB <- spawnPipe conkyBar
	xmonad $ defaultConfig
		{ terminal = myTerminal 
		, workspaces = myWorkspaces
		, manageHook = manageDocks <+> manageHook defaultConfig
		, layoutHook = myLayoutHook
                , modMask = mod4Mask -- bind to Windows key
                , borderWidth = myBorderWidth
                , normalBorderColor = myNormalBorderColor
                , focusedBorderColor = myFocusedBorderColor
                , logHook = dynamicLogWithPP $ myDzenPP dzen
                , startupHook = myStartupHook
                }

myTerminal = "xterm /bin/zsh"

myWorkspaces = ["1:main", "2:misc", "3", "4", "5", "6", "7", "8", "9"]

myBorderWidth = 1
myNormalBorderColor = "grey30"
myFocusedBorderColor = "#1994d1"
myStartupHook = startup
myLayoutHook = avoidStruts (tiled ||| Mirror tiled ||| noBorders Full)
   where
     tiled = Tall 1 (3/100) (3/5)


startup :: X()
startup = do
	spawn "dropbox start"

myStatusBar = "dzen2  -h '12' -w '1920' -ta l -xs 1 -fg white -bg black -fn '-*-terminus-*-*-*-*-*-*-*-*-*-*-*'"
conkyBar = "conky -c ~/.conkyrc | dzen2 -ta r -h 12 -w '1920' -xs 2 -bg black -fn '-*-terminus-*-*-*-*-*-*-*-*-*-*-*'"

---------------------------------------------------------------------
-- DZEN looks --
myDzenPP handle = defaultPP
        { ppCurrent       = wrap ("^fg(" ++ myFocusedFGColor ++ ")^bg(" ++ myFocusedBGColor ++ ")^p(2)^i(" ++ xmonadDir ++ "/dzen_bitmaps/has_win.xbm)") "^p(4)^fg()$"
        , ppUrgent        = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p(4)") "^p(4)^fg()^bg()"
        , ppVisible       = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myNormalBGColor ++ ")^p(4)") "^p(4)^fg()^bg()"
        , ppHiddenNoWindows = wrap ("^fg(" ++ myNormalFGColor ++ ")")"^fg()"
        , ppHidden        = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myVisibleBGColor ++ ")^p(4)") "^p(4)^fg()^bg()"
        , ppSep           = ""
        , ppTitle         = dzenColor myNormalFGColor "" . wrap "< " " >"
        , ppOutput        = hPutStrLn handle
        , ppLayout        = dzenColor myFocusedFGColor "" .
                            (\x -> case x of
                                "Tall" -> "^p(4)^i(" ++ xmonadDir ++ "/dzen_bitmaps/tall.xbm)^p(4)"
                                "Mirror Tall" -> "^p(4)^i(" ++ xmonadDir ++ "/dzen_bitmaps/mtall.xbm)^p(4)"
                                "Full" -> "^p(4)^i(" ++ xmonadDir ++ "/dzen_bitmaps/full.xbm)^p(4)"
                            )
}
