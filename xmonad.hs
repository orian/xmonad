import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Run(safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myModMask = mod3Mask

myWorkspaces = ["0", "1", "2", "3", "4", "5", "6", "7"]

main = do
    xmproc <- spawnPipe "xmobar /home/pawel/.xmobarrc"

    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = myModMask     -- Rebind Mod to the Windows key
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        , borderWidth = 3
        , workspaces = myWorkspaces
        } `additionalKeys`
        [ ((myModMask .|. shiftMask, xK_l    ), spawn "gnome-screensaver-command --lock; xset dpms force off")
        , ((controlMask,             xK_Print), spawn "sleep 0.2; scrot -s")
        , ((myModMask,               xK_Print), spawn "scrot")
        , ((myModMask,               xK_g    ), spawn "google-chrome")
	, ((myModMask,               xK_f    ), spawn "firefox")
        , ((myModMask,               xK_p    ), safeSpawn "dmenu_run" [])
        , ((myModMask .|. shiftMask, xK_p    ), safeSpawn "gmrun" [])
        , ((myModMask,               xK_Down),  nextWS)
        , ((myModMask,               xK_Up),    prevWS)
        , ((myModMask .|. shiftMask, xK_Down),  shiftToNext >> nextWS)
        , ((myModMask .|. shiftMask, xK_Up),    shiftToPrev >> prevWS)
        -- , ((myModMask,               xK_Right), nextScreen)
        -- , ((myModMask,               xK_Left),  prevScreen)
        -- , ((myModMask .|. shiftMask, xK_Right), shiftNextScreen)
        -- , ((myModMask .|. shiftMask, xK_Left),  shiftPrevScreen)
        -- , ((myModMask,               xK_z),     toggleWS)
        , ((myModMask,               xK_b),     sendMessage ToggleStruts)
        ]
