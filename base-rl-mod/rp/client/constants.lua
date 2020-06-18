screenWidth, screenHeight = guiGetScreenSize()

XTREAM_ORANGE = {255,100,0}
XTREAM_ORANGE_TOCOLOR = tocolor(XTREAM_ORANGE)

DEBUG = false

function load_after_login_constants()
    TEAM_RANKS = {
        [5] = { _"ADMINRANK_5_1" },
        [4] = { _"ADMINRANK_4_1",
                _"ADMINRANK_4_2",
                _"ADMINRANK_4_3" },
        [3] = { _"ADMINRANK_3_1" },
        [2] = { _"ADMINRANK_2_1" },
        [1] = { _"ADMINRANK_1_1" },
        [0] = { _"DEFAULTRANK" }
    }   
end