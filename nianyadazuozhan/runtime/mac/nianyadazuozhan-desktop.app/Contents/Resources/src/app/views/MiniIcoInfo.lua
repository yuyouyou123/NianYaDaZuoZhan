local MiniIcoInfo = class("MiniIcoInfo",cc.Node)

local newtag = 0x02


local groupIco = {}

local icoMoveSpeed = 500

function MiniIcoInfo.public_SetSpeed(speed)
	icoMoveSpeed = speed or icoMoveSpeed
end

function MiniIcoInfo.public_SetAllSpeed(speed)
	icoMoveSpeed = speed or icoMoveSpeed
	for _,ico in ipairs(groupIco) do
		ico:updateMove(speed)
	end
end

function MiniIcoInfo.public_stopAllIco()
	
end


function MiniIcoInfo.public_getGroup()
	return groupIco
end



function MiniIcoInfo.onCreate(info)
    local obj = MiniIcoInfo.new()
    obj.info = info or {}
    table.insert(groupIco,obj)
    return obj

end

function MiniIcoInfo:getScriptContentSize()
	return self._sprite:getContentSize()
end

function MiniIcoInfo:init()
	local image = self.info.image or 'mini_game_res/player.png'
    local sprite = cc.Sprite:create(image)
        :setAnchorPoint(cc.p(0.5,0))
        :addTo(self)
        :setPosition(cc.p(0,-10))

    local size = sprite:getContentSize()

    local bulletBody = cc.PhysicsBody:createBox(cc.size(size.width - 2,size.height - 50),cc.PhysicsMaterial(1000, 0, 0.5))
    bulletBody:setCategoryBitmask(0x02)   
    bulletBody:setContactTestBitmask(0x01)
    bulletBody:setCollisionBitmask(0x02)
    bulletBody:setGravityEnable(true)

    bulletBody:setVelocity(cc.pMul(cc.pNormalize(cc.p(-1,0)), icoMoveSpeed))

    bulletBody:setRotationEnable(false)

    bulletBody:setPositionOffset(cc.p(0, size.height / 2 - 25))
    -- bulletBody:setDynamic(true)
    -- bulletBody:setMass(10)
    -- bulletBody:setLinearDamping(100)
    -- bulletBody:setAngularDamping(100)

    -- sprite:runAction(cc.MoveBy:create(3,cc.p(-display.width - 100,0)))

    -- bulletBody:setOwner(sprite)
    self:setPhysicsBody(bulletBody)

    self._physics = bulletBody

    self._sprite = sprite

    self:runAction(
        cc.RepeatForever:create(
            cc.Sequence:create(
                cc.CallFunc:create(handler(self,self.update)),
                cc.DelayTime:create(0.2)
                )
            )
        )
end


--被压中
function MiniIcoInfo:isIco(loginScene)


    -- self:stopAllActions()
    if self.info.deleteImage then
        self._sprite:setTexture(self.info.deleteImage)
        self._sprite:setPositionY(-55)
    end
    self._physics:setContactTestBitmask(0)
    -- cc.Director:getInstance():getRunningScene():getPhysicsWorld():removeBody(self._physics)
    if self.info.isOver then
        audio.playSound("audio/boom.mp3")
        self._sprite:setVisible(false)
        local spinepath = "action/nydzz_explosion/nydzz_explosion"
        local spine = sp.SkeletonAnimation:createWithBinaryFile(spinepath..".skel", spinepath..".atlas", 1)
        -- spine:setPosition(display.center)
        spine:setAnimation(0, "animation", false)
        spine:registerSpineEventHandler(function()
            self:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(0.02),
                    cc.CallFunc:create(function()
                        loginScene:gameOverStatic()
                        self:removeSelfIco()
                    end)
                )
            )
        end, sp.EventType.ANIMATION_COMPLETE)
        spine:addTo(self,6)
    else
        audio.playSound("audio/ico.mp3")
        local path = "action/fruit_juice/fruit_juice.plist"
        cc.ParticleSystemQuad:create(path)
            :setAutoRemoveOnFinish(false)
            :addTo(self)
            :setPosition(cc.p(0,20))

        path = "action/fruit_juice/fruit_juice1.plist"
        local partic = cc.ParticleSystemQuad:create(path)
            :setAutoRemoveOnFinish(false)
            :addTo(self)
            :setPosition(cc.p(0,20))
        loginScene:addIco()
        self:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(partic:getLife()),
                cc.CallFunc:create(function(node)
                    self:removeSelfIco()
                end)
            )
        )
    end

	-- self:removeSelfIco()
end

--设置移动
function MiniIcoInfo:updateMove()
    self._physics:setVelocity(cc.pMul(cc.pNormalize(cc.p(-1,0)), icoMoveSpeed))
end

function MiniIcoInfo:update()
    if self._physics:getVelocity().x < icoMoveSpeed  then
        self._physics:setVelocity(cc.pMul(cc.pNormalize(cc.p(-1,0)), icoMoveSpeed))
    end

    if self._physics:getOwner():getPositionX() <= -display.width - self:getScriptContentSize().width + 10 then
		self:removeSelfIco()
    end
end


function MiniIcoInfo:removeSelfIco()
	for i,v in ipairs(groupIco) do
		if v == self then
			table.remove(groupIco,i)
			break
		end
	end
	self:removeSelf()
end

function MiniIcoInfo:getInfo()
	return self._info
end

return MiniIcoInfo