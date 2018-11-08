-- AnimFrameData = {
--     -- 起始帧
--     startFrame = nil;
--     -- 该动画总帧数
--     frameNum = nil;
-- };

-- AnimData = {
--     images = nil;
--     animFrameDatas = nil;
-- };


AnimatedSprite = {
    animData = nil;
    animNum = nil;

    -- 当前在该动画的第几帧
    frameIndex = nil;
    -- 当前帧经过的时间
    frameTime = nil;
    animFPS = 12;
    image = nil;

    animatedSpriteList = {};
    isUpdate = false;
};
AnimatedSprite.__index = AnimatedSprite;
setmetatable(AnimatedSprite.animatedSpriteList, {__mode = {"v"}});

function AnimatedSprite:new(animData, animNum)
    -- body
    local obj = obj or {};
    setmetatable(obj, self);
    obj.animData = animData;
    table.insert(self.animatedSpriteList, obj);
    obj:playAnim(animNum);
    return obj;
end

function AnimatedSprite:playAnim(animNum)
    -- body
    self.animNum = animNum;
    self.frameIndex = 0;
    self.frameTime = 0;
    local path = self.animData.images[self.animData.animFrameDatas[animNum].startFrame];
    self:showImage(path);
    if not AnimatedSprite.isUpdate then
        AnimatedSprite.isUpdate = true;
        gscript.add_script(gscript.FUNCTION_UPDATE, "updateAllAnimatedSprite");
    end
end

function AnimatedSprite:update(dt)
    -- body
    self.frameTime = self.frameTime + dt;
    if self.frameTime > (1 / self.animFPS) then
        -- 计算跳到第几帧
        self.frameIndex = self.frameIndex + math.floor(self.frameTime / (1 / self.animFPS));
        -- 计算是否执行到动画的最后一帧
        if self.frameIndex >= self.animData.animFrameDatas[self.animNum].frameNum then
            self.frameIndex = self.frameIndex % self.animData.animFrameDatas[self.animNum].frameNum;
        end
        self.frameTime = self.frameTime % (1 / self.animFPS);
    end
    local path = self.animData.images[self.animData.animFrameDatas[self.animNum].startFrame + self.frameIndex];
    self:showImage(path);
end

function AnimatedSprite:showImage(path)
    -- body
    if self.image == nil then
        self.image = simage.create_simage();
        self.image:show();
    end
    self.image:set_bitmap_path(path);
end

function updateAllAnimatedSprite(dt)
    -- body
    for k,v in pairs(AnimatedSprite.animatedSpriteList) do
        v:update(dt);
    end
end

-- example

local animData = {
    images = {
        "anim/jindutiaohd_01.png",
        "anim/jindutiaohd_02.png",
        "anim/jindutiaohd_03.png",
        "anim/jindutiaohd_04.png",
        "anim/jindutiaohd_05.png",
        "anim/jindutiaohd_06.png",
        "anim/gnkaiqihudie1_01.png",
        "anim/gnkaiqihudie1_02.png",
        "anim/gnkaiqihudie1_03.png",
        "anim/gnkaiqihudie1_04.png",
        "anim/gnkaiqihudie1_05.png",
        "anim/gnkaiqihudie1_06.png",
        "anim/gnkaiqihudie1_07.png",
        "anim/gnkaiqihudie1_08.png",
        "anim/gnkaiqihudie1_09.png",
        "anim/gnkaiqihudie1_10.png",
        "anim/gnkaiqihudie1_11.png",
        "anim/gnkaiqihudie1_12.png",
        "anim/gnkaiqihudie1_13.png",
    };
    animFrameDatas = {
        [1] = {
            startFrame = 1;
            frameNum = 6;
        };
        [2] = {
            startFrame = 7;
            frameNum = 13;
        };
    };
};
local animSprite = AnimatedSprite:new(animData, 1);

gtime.create("playAnim", 3000, -1);
function playAnim( ... )
    -- body
    if index == nil then
        index = 0;
    end
    index = index + 1;
    animSprite:playAnim((index % 2) + 1);
end