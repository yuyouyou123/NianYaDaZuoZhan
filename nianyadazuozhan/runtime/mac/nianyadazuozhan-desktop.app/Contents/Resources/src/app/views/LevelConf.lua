local LevelConf = {}
local self = LevelConf

self.defaultOffsetSpeed = 500 --水果默认的移动速度

self.playerDownOffsetSpeed = 3000 --锤子向下闸的速度

self.addHardLevelCount = 5  --每过多少关增加一次水果的移动速度
self.addHardSpeedValue = 0.2  --每次增加多少倍速度
self.levelAddCount = 2 				--每次过关后增加的最大经验值时多少

self.defaultOneExp = 5			--第一关的默认最大的经验值


--水果配置
self.icoConf = {
    {
        image = "mini_game_res/ico/boluo.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/caomei.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/chengzi.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/fanqie.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/huanggua.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_green.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/huanglajiao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/huluobu.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
     {
        image = "mini_game_res/ico/lajiao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/nangua.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/ningmong.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/pingguo.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_green.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/putao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_purple.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/qiezi.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_purple.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/rose_gold.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/tudou.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/xiangjiao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/xigua.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/yangcong.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
	{
        image = "mini_game_res/ico/yintao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/yumi.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
    },
    {
        image = "mini_game_res/ico/zhadan.png",
        isOver = true,
    },
    {
        image = "mini_game_res/ico/zhadan2.png",
        isOver = true,
    },
}


return LevelConf