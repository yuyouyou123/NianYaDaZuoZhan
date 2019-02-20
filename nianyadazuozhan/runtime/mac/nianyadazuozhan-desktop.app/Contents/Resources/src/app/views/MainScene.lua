-- local CustomBaseScene = require("CustomBaseScene")
local MainScene = class("MainScene", cc.load("mvc").ViewBase);

local csbFilePath = 'MiniGameLayer.csb'
local groundTag = 0x06
local playerBodyTag = 0x07
local newtag = 0x02

local upGround = 0x0e

local defIcoMoveSpeed = 500


local difficulty = 0 --困难度


local newIcoMoveSpeed = 0

local playerMoveSpeed = 3000


local nowGroundSpeedLevel = 0 --当前的ground的速度等级
local level = 0 --  当前关卡等级

local addSpeedLevel = 1 --每几关增加一次速度
local addSpeedV = 0.1 --每次增加原来速度的多少



local nowNumber = 0 --当前的分数
local maxNumber = 5 --默认的第一关个数

local levelAddCount = 2 --每过一关需要增加的个数





local GameStateEnum = {
    None = 0; --无
    Runing = 1, --运行中
    Pause = 2,  --暂停中
    Over = 3,   --结束
}


--水果配置
local icoConf = {
    {
        image = "mini_game_res/ico/boluo.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
        zorder = 1,
    },
    {
        image = "mini_game_res/ico/lajiao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = true,
        zorder = 2,
    },
    {
        image = "mini_game_res/ico/nangua.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
        zorder = 3,
    },
    {
        image = "mini_game_res/ico/qiezi.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_purple.png',
        isOver = false,
        zorder = 4,
    },
    {
        image = "mini_game_res/ico/xigua.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_green.png',
        isOver = false,
        zorder = 5,
    },
    {
        image = "mini_game_res/ico/yangcong.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_red.png',
        isOver = false,
        zorder = 6,
    },
    {
        image = "mini_game_res/ico/yumi.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
        zorder = 7,
    },
    {
        image = "mini_game_res/ico/huanglajiao.png",
        deleteImage = 'mini_game_res/ico/delete/nydzz_fruit_yellow.png',
        isOver = false,
        zorder = 8,
    },
}



local MiniIcoInfo = require('app.views.MiniIcoInfo')


function MainScene.initDefaultData()
    local LevelConf = require('app.views.LevelConf')
    defIcoMoveSpeed = LevelConf.defaultOffsetSpeed

    playerMoveSpeed = LevelConf.playerDownOffsetSpeed

    addSpeedLevel = LevelConf.addHardLevelCount --每几关增加一次速度
    addSpeedV = LevelConf.addHardSpeedValue --每次增加原来速度的多少

    maxNumber = LevelConf.defaultOneExp --默认的第一关个数

    levelAddCount = LevelConf.levelAddCount --每过一关需要增加的个数

    icoConf = LevelConf.icoConf
end

function MainScene:onCreate()
    MainScene.initDefaultData()
	self.csNode = cc.CSLoader:createNode(csbFilePath)
    self.csNode:addTo(self)
    self:init()

end
-- function MainScene.createScene()
--     local scene = cc.Scene:createWithPhysics()
--     scene:addChild(MainScene:create())
--     scene:getPhysicsWorld():setGravity(cc.vertex2F(0, 0))
--     scene:getPhysicsWorld():setAutoStep(false)
--     -- scene:getPhysicsWorld():setDebugDrawMask(1)
--     return scene
-- end
function MainScene:init()
	audio.playMusic("audio/bg.mp3", true)    
    newIcoMoveSpeed = defIcoMoveSpeed
    -- self._scheduler = cc.Director:getInstance():getScheduler()
    -- self._fireSchedulerID = self._scheduler:scheduleScriptFunc(handler(self,self.newIco),2, true)
    -- self._scheduler:unscheduleScriptEntry(self._fireSchedulerID)

    self._panel = self.csNode:getChildByName('Panel_1')
    self._hammerNode = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Hammer')

    self._hammer = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Hammer')
        :getChildByName('HammerLong'):getChildByName('Hammer')
    self._partHammerLong = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Hammer')
        :getChildByName('HammerLong')

    self._partShort = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Hammer'):getChildByName('HammerShort')

    self.Node_Icos = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Ico')


    self._groundsNode = self.csNode:getChildByName('Panel_1'):getChildByName('grounds')
    self._pause_button = self.csNode:getChildByName('Panel_1'):getChildByName('Pause_button')
    self._pause_button:loadTextureNormal('mini_game_res/nydzz_level_start.png')
    


    self._stopGamePanel = self.csNode:getChildByName('Panel_1'):getChildByName('Stop_Game')


    local test = self.csNode:getChildByName('Sprite_1')
    if test then
        test:removeSelf()
    end


    -----
    self._panel_Select = self.csNode:getChildByName('Panel_Select')
    self._simple_button = self.csNode:getChildByName('Panel_Select'):getChildByName('Simple')
    self._hard_button = self.csNode:getChildByName('Panel_Select'):getChildByName('Hard')
    ----
    self._panel_Whit = self.csNode:getChildByName('Panel_Whit')
    self._start_button = self.csNode:getChildByName('Panel_Whit'):getChildByName('Start_button')
    ----



    self._panel:setVisible(false)

    self._panel_Select:setVisible(false)
    -- self._hammerNode:setVisible(false)
    -- self._pause_button:setVisible(false)

    ---按钮
    self._start_button:addClickEventListener(
        function()
            self._panel_Whit:setVisible(false)
            self._panel_Select:setVisible(true)
        end
        )
    self._pause_button:addClickEventListener(handler(self, self.pauseOnClicked))

    self._simple_button:addClickEventListener(function()
        difficulty = 1
        self:runGame()
    end)

    self._hard_button:addClickEventListener(function()
        difficulty = 2
        self:runGame()
    end)
    -----
    self.gameStateOver = GameStateEnum.None



    self:initCreateGround()
    self:initCreatePlayer()


    ---新的图标的产生动画
    self.newIcoAction = cc.Speed:create(
        cc.RepeatForever:create(
            cc.Sequence:create(
                cc.CallFunc:create(handler(self,self.newIco)),
                cc.DelayTime:create(1)
                )
        ), 0)

    self:runAction(self.newIcoAction)
    local listener = cc.EventListenerTouchAllAtOnce:create()
    -- listener:registerScriptHandler(handler(self, self.onTouchesBegan), cc.Handler.EVENT_TOUCHES_BEGAN)
    -- listener:registerScriptHandler(handler(self, self.onTouchesMoved), cc.Handler.EVENT_TOUCHES_MOVED)
    listener:registerScriptHandler(handler(self, self.onTouchesEnded), cc.Handler.EVENT_TOUCHES_ENDED)
    -- listener:registerScriptHandler(handler(self, self.onTouchesCancelled), cc.Handler.EVENT_TOUCHES_CANCELLED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.csNode:getChildByName('Panel_1'))

    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(handler(self, self.onCollisionHandling), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    -- contactListener:registerScriptHandler(handler(self, self.onCollisionHandling), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    -- contactListener:registerScriptHandler(handler(self, self.onCollisionHandling), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)


    self:getNumberNodes()

    self:updateShowNumber()

    local  function update(delta)
      for i=1,3 do
        cc.Director:getInstance():getRunningScene():getPhysicsWorld():step(1/180.0)
      end
    end

    self:scheduleUpdateWithPriorityLua(update, 0)
end


function MainScene:pauseOnClicked()
    if self.gameStateOver == GameStateEnum.Pause then
        self.gameStateOver = GameStateEnum.Runing
        self._stopGamePanel:setVisible(false)
        self._pause_button:loadTextureNormal('mini_game_res/nydzz_level_start.png') 

    elseif self.gameStateOver == GameStateEnum.Runing then
        self.gameStateOver = GameStateEnum.Pause
        self._stopGamePanel:setVisible(true)
        self._pause_button:loadTextureNormal('mini_game_res/nydzz_pause_button.png')
    end
    self:runUpdateSpeed()
end

--运行游戏
function MainScene:runGame()
    -- playerMoveSpeed = playerMoveSpeed --+ (playerMoveSpeed * 1 / difficulty)

    self._panel_Select:setVisible(false)
    self._panel:setVisible(true)


    self.gameStateOver = GameStateEnum.Runing
    self._stopGamePanel:setVisible(false)
    self._hammerNode:setVisible(true)

    self:runUpdateSpeed()
end

function MainScene:runUpdateSpeed()
    if self.gameStateOver == GameStateEnum.Runing then
        self.newIcoAction:setSpeed(1 * difficulty + nowGroundSpeedLevel * addSpeedV)
        for i,round in ipairs(self.grounds) do
            round.moveAction:setSpeed(1 * difficulty + nowGroundSpeedLevel * addSpeedV)
        end
        MiniIcoInfo.public_SetAllSpeed(newIcoMoveSpeed * difficulty)
    else
        for i,round in ipairs(self.grounds) do
            round.moveAction:setSpeed(0)
        end
        self.newIcoAction:setSpeed(0)
        MiniIcoInfo.public_SetAllSpeed(0)
    end
end

function MainScene:initCreateGround()
    self.grounds = {}
    for _,node in ipairs(self._groundsNode:getChildren()) do
        local ground = {}
        ground.node = node

        local size = node:getContentSize()
        -- local groundBody = cc.PhysicsBody:createEdgeSegment(cc.p(size.width,0), cc.PhysicsMaterial(1, 0.1, 0))
        -- local groundBody = cc.PhysicsBody:createBox({width = size.width - 5, height = 100}, cc.PhysicsMaterial(1, 1000, 1))
        -- groundBody:setCategoryBitmask(10)    --0101    
        -- groundBody:setContactTestBitmask(9) -- 0010
        -- groundBody:setCollisionBitmask(9)   --0010
        -- -- groundBody:setDynamic(false)
        -- groundBody:setPositionOffset(cc.p(0,-size.height / 4 - 10))
        -- groundBody:setTag(groundTag)
        -- -- groundBody:setGravityEnable(false)
        -- groundBody:setDynamic(false)

        -- groundBody:setRotationEnable(false)
        -- groundBody:setLinearDamping(100)
        -- node:setPhysicsBody(groundBody)

        -- ground.physics = groundBody

        ground.moveAction = --node:runAction(
            cc.Speed:create(
                cc.RepeatForever:create(
                    cc.Sequence:create(
                        cc.MoveBy:create(size.width / newIcoMoveSpeed ,cc.p(-size.width,0)),
                        cc.CallFunc:create(function(node)
                            local x = node:getPositionX()
                            if x <= 0 then
                                node:setPositionX(x + size.width)
                            end
                        end)
                        )
                    ),
                    0
                )
        node:runAction(ground.moveAction)
        self.grounds[#self.grounds + 1] = ground
    end
    local size = display.size
    local dontHammer = self.csNode:getChildByName('Panel_1'):getChildByName('Node_Hammer'):getChildByName("Sprite_2")
    local groundBody2 = cc.PhysicsBody:createBox({width = size.width, height = 100}, cc.PhysicsMaterial(1, 0.1, 0))
    groundBody2:setCategoryBitmask(10)    --0101
    groundBody2:setContactTestBitmask(9) -- 0010
    groundBody2:setCollisionBitmask(9)   --0010
    -- groundBody2:setDynamic(false)
    groundBody2:setRotationEnable(false)
    groundBody2:setTag(upGround)
    -- groundBody2:setGravityEnable(false)
    groundBody2:setPositionOffset(cc.p(0 / 2,-230))
    groundBody2:setDynamic(false)

    dontHammer:setPhysicsBody(groundBody2)
    local node = cc.Node:create()
        :addTo(dontHammer)
    local groundBody3 = cc.PhysicsBody:createBox({width = size.width, height = 100}, cc.PhysicsMaterial(1, 0.1, 0))
    groundBody3:setCategoryBitmask(10)    --0101
    groundBody3:setContactTestBitmask(9) -- 0010
    groundBody3:setCollisionBitmask(9)   --0010
    -- groundBody3:setDynamic(false)
    groundBody3:setRotationEnable(false)
    groundBody3:setTag(groundTag)
    -- groundBody3:setGravityEnable(false)
    groundBody3:setPositionOffset(cc.p(50 / 2,-600))
    groundBody3:setDynamic(false)

    node:setPhysicsBody(groundBody3)

    -- local edgeBody = cc.PhysicsBody:createBox(cc.size(size.width,800))
    -- edgeBody:setCategoryBitmask(10)    --0101
    -- edgeBody:setContactTestBitmask(9) -- 0010
    -- edgeBody:setCollisionBitmask(9)
    -- edgeBody:setDynamic(false)
    -- edgeBody:setPositionOffset(cc.p(size.width / 2,800 / 2))
    -- self:setPhysicsBody(edgeBody)

end

function MainScene:initCreatePlayer()

    local size = self._hammer:getContentSize()
    -- local playerBody = cc.PhysicsBody:createEdgeSegment(cc.p(size.width,10), cc.PhysicsMaterial(1, 0.1, 0))
    local playerBody = cc.PhysicsBody:createBox({width = size.width - 50, height = 10}, cc.PhysicsMaterial(1, 0, 0))
    playerBody:setCategoryBitmask(9)    --0111
    playerBody:setContactTestBitmask(0x02) --0010
    playerBody:setCollisionBitmask(0x08)   --0010
    -- playerBody:setVelocity(cc.pMul(cc.pNormalize(cc.p(0,-1)), 500))
    playerBody:setGravityEnable(false)
    playerBody:setDynamic(false)
    -- playerBody:setPositionOffset(cc.p(0,- size.height / 2 + 10))
    playerBody:setPositionOffset(cc.p(0,-590))
    playerBody:setTag(playerBodyTag)
    -- self._hammer:setPhysicsBody(playerBody)
    self._partHammerLong:setPhysicsBody(playerBody)

    self.playerBody = playerBody

    local node = cc.Node:create()
        :addTo(self._hammer)
    local playerBody_2 = cc.PhysicsBody:createBox({width = 10, height = size.height - 20}, cc.PhysicsMaterial(1, 0, 0))
    playerBody_2:setCategoryBitmask(0x02)    --0101
    playerBody_2:setContactTestBitmask(0x00) --0011 -> 0010
    playerBody_2:setCollisionBitmask(0x02)   --0010
    -- playerBody_2:setVelocity(cc.pMul(cc.pNormalize(cc.p(0,-1)), 500))

    playerBody_2:setGravityEnable(false)
    playerBody_2:setDynamic(false)
    playerBody_2:setPositionOffset(cc.p(size.width,size.height / 2))
    -- playerBody_2:setTag(0x119)
    node:setPhysicsBody(playerBody_2)

    -- local node_2 = cc.Node:create()
    --     :addTo(sprite)
    -- local playerBody_3 = cc.PhysicsBody:createBox({width = size.width, height = 10}, cc.PhysicsMaterial(1, 0.1, 0))
    -- playerBody_3:setCategoryBitmask(playerBodyTag)    --0101
    -- playerBody_3:setContactTestBitmask(0x02) --0011 -> 0010
    -- -- playerBody_3:setCollisionBitmask(0x04)   --0010
    -- playerBody_3:setPositionOffset(cc.p(0,size.height))
    -- playerBody_3:setTag(playerBodyTag)
    -- playerBody_3:setDynamic(false)
    -- node_2:setPhysicsBody(playerBody_3)



    -- self.playerBody = cc.PhysicsBody:createBox({width = 10, height = 10}, cc.PhysicsMaterial(0, 0, 0))
    -- self.playerBody:setGravityEnable(false)
    -- self.playerBody:setDynamic(false)

    -- self.playerBody:setGravityEnable(false)
    -- self._partHammerLong:setPhysicsBody(self.playerBody)

end


function MainScene:onTouchesEnded(event)
    if not self.playerBody or tolua.isnull(self.playerBody) then
        self:initCreatePlayer()
    end
    if self.playerBody:getOwner():getPositionY() < -550 then
        return 
    end
    self._partShort:stopAllActions()
    self._partShort:runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(0.1, 1, 1.5, 1),
            cc.ScaleTo:create(0.2, 1, 1, 1)
        )
    )

    self.playerBody:setVelocity(cc.pMul(cc.pNormalize(cc.p(0,-1)), playerMoveSpeed))
end


local maxCount = 4 --最大能有多少个水果在待咂区
function MainScene:newIco()
    if self.gameStateOver ~= GameStateEnum.Runing then
        return 
    end


    local icos = MiniIcoInfo.public_getGroup()

    local count = 0
    for _,ico in ipairs(icos) do
        if ico._physics:getOwner():getPositionX() > -display.size.width / 2 then
            count = count + 1
        end
    end

    if count >= maxCount then
        return
    end

    local info = icoConf[math.random(1,#icoConf)]
    local ico = MiniIcoInfo.onCreate(info)
    ico:init()
    ico:addTo(self.Node_Icos)

    -- local size = ico:getScriptContentSize()
    -- ico:setPosition(cc.p(size.width / 2, size.height))
end



local isPlayIco = false
function MainScene:onCollisionHandling(contact)
    local pBodyA = contact:getShapeA():getBody()
    local pBodyB = contact:getShapeB():getBody()

    local aTag = pBodyA:getTag()
    local bTag = pBodyB:getTag()
    -- print('发生了碰撞')
    -- print(aTag,'pBodyA',bTag,'pBodyB')


    local playerBody = nil
    local otherBody = nil
    if bTag == playerBodyTag then
        playerBody = pBodyB
    elseif aTag == playerBodyTag then
        playerBody = pBodyA
    end

    otherBody =  playerBody == pBodyB and pBodyA or pBodyB



    -- print(otherBody:getOwner():getParent().__cname,'popopopppppppp')

    -- if otherBody:getOwner():getParent().isIco then
    if otherBody:getOwner().__cname == "MiniIcoInfo" then
        -- otherBody:getOwner():removeSelf()
        otherBody:getOwner():isIco(self)
        isPlayIco = true
        -- cc.Director:getInstance():getRunningScene():getPhysicsWorld():removeBody(pBodyB)
        return 
    end
    if otherBody:getTag() == groundTag then
        if self.playerBody and self.playerBody:getVelocity().y ~= 0 then
            if isPlayIco then
            else
                audio.playSound("audio/nil.mp3", isLoop)
            end
            isPlayIco = false

            -- print(self.playerBody:getOwner():getPositionY(),'popopopopopoo')
            self.playerBody:setVelocity(cc.pMul(cc.pNormalize(cc.p(0,1)), playerMoveSpeed * 0.3))

        end

        return
    end

    if otherBody:getTag() == upGround then
        if self.playerBody then
            self.playerBody:setVelocity(cc.pMul(cc.pNormalize(cc.p(0,0)), 0))
        end
        return
    end

end

function MainScene:gameOverStatic()
    self.gameStateOver = GameStateEnum.Over
    nowNumber = 0
    self:updateShowNumber()
    self:runUpdateSpeed()
    self._panel_Whit:setVisible(true)

end

function MainScene:addIco()
    nowNumber = nowNumber + 1
    self:updateShowNumber()
end


function MainScene:upLevelPanle()
    if not self.continuePanel then
        local layout = ccui.Layout:create()
        :addTo(display.getRunningScene())
        :setContentSize(cc.size(display.width + 200,display.height + 100))
        :setAnchorPoint(cc.p(0.5,0.5))
        :setPosition(cc.p(display.cx,display.cy))
        :setBackGroundColorType(LAYOUT_COLOR_SOLID)
        :setBackGroundColor(cc.c3b(0, 0, 0))
        :setBackGroundColorOpacity(80)
        :setTouchEnabled(true)
        -- CustomHelper.adapterPosWithSafeAreaRect(layout,2)
        
        self.continuePanel = layout
        self.continuePanel:onTouch(function(event)
            if event.name =="ended" then
                self:pauseOnClicked()
                self.continuePanel:setVisible(false)
            end
        end)
    end

    self.continuePanel:setVisible(true)
    self.gameStateOver = GameStateEnum.Pause
    self:runUpdateSpeed()

    local spine = self.continuePanel:getChildByName('spine')
    if spine then

    else
        local spinepath = "action/nydzz_firework/nydzz_firework"
        spine = sp.SkeletonAnimation:createWithBinaryFile(spinepath..".skel", spinepath..".atlas", 1)
        spine:setPosition(display.center)
        spine:setAnimation(0, "animation", true)
        spine:setName('spine')
        -- spine:registerSpineEventHandler(function()
        --     Animations.delayRemoveself(spine, {time = 0.1})
        -- end, sp.EventType.ANIMATION_COMPLETE)
        spine:addTo(self.continuePanel)
    end


end

function MainScene:updateShowNumber()

    local v =  nowNumber / maxNumber

    self._nowNumber_text:setString(level)
    self._maxNumber_text:setString(level + 1)
    self._nowNumber_Progres:setContentSize(cc.size(self._progresSize.width * v,self._progresSize.height))
    if nowNumber == maxNumber then
        self:clearNowLevelData()
        return
    end
end

--通关
function MainScene:clearNowLevelData()
    maxNumber = maxNumber + levelAddCount
    nowNumber = 0
    level = level + 1
    if level % addSpeedLevel == 0 then
        nowGroundSpeedLevel = nowGroundSpeedLevel + 1
        newIcoMoveSpeed = defIcoMoveSpeed + nowGroundSpeedLevel * addSpeedV * defIcoMoveSpeed
        -- self.gameStateOver = GameStateEnum.Pause
        self:runUpdateSpeed()
    end
    audio.playSound("audio/win.mp3", isLoop)
    
    self:updateShowNumber()

    self:upLevelPanle()
end

function MainScene:getNumberNodes()
    self._nowNumber_Progres = self.csNode:getChildByName('Panel_1'):getChildByName('progressBg'):getChildByName('progress')
    self._nowNumber_text = self.csNode:getChildByName('Panel_1'):getChildByName('Now_Number_Bg'):getChildByName('Text_Number_Now')
    self._maxNumber_text = self.csNode:getChildByName('Panel_1'):getChildByName('Max_Number_Bg'):getChildByName('Text_Number_Max')
    self._progresSize = self.csNode:getChildByName('Panel_1'):getChildByName('progressBg'):getContentSize()

end

return MainScene
