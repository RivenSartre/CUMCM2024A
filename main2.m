clc
clear
close all

%% 螺线初始化
pitch = 1.7;
ratio = 1000000;
[x,y] = SpireCurve(pitch, ratio);

%% 判断行进队伍是否合理
% 首先我们假定一条队伍
Timelist = 120;
SpeedHead = 1;
LengthHead = SpeedHead * Timelist;
tempLength = [];
for i = 1:length(x)-1
    tempLength(i) = sqrt((x(i+1) - x(i))^2 + (y(i+1) - y(i))^2);
end
SpireLength = cumsum(tempLength);

for i = 1:length(Timelist)
    idx(i) = find(SpireLength > LengthHead(i),1);
    plot(x(idx(i)), y(idx(i)),'o','color','r', 'LineWidth', 2);
    text(x(idx(i))+0.5, y(idx(i))+0.5, num2str(Timelist(i)));
end

PositionHeadX = x(idx);
PositionHeadY = y(idx);
PositionHead = [PositionHeadX',PositionHeadY'];

% 算全身坐标
tableHead = 3.41 - 0.275*2;
tableBody = 2.20 - 0.275*2;

level = find(SpireLength>tableBody,1);
% 算头
tempLength = [];
Position = [];
for i = idx:-1:1
    tempLength(i) = sqrt((x(i) - PositionHeadX)^2 + (y(i) - PositionHeadY)^2);
end
Distance_H2P = flip(tempLength);
jdx = length(Distance_H2P)-find(Distance_H2P > tableHead,1);
Position(1,:) = [x(jdx), y(jdx)];
jdxlist = [jdx];

% 算身子
k = 1;
while jdx >level
    tempLength = [];
    for i = jdx:-1:1
        tempLength(i) = sqrt((x(i) - Position(k,1))^2 + (y(i) - Position(k,2))^2);
    end
    Distance_H2P = flip(tempLength);
    jdx = length(Distance_H2P)-find(Distance_H2P > tableBody,1);
    Position(k+1,:) = [x(jdx), y(jdx)];
    if k > 220
        break
    end
    k = k+1;
    jdxlist = [jdxlist, jdx];
    
end

plot(Position(:,1), Position(:,2),'o','color','g','LineWidth', 2);

[flag] = BoundaryST(x, y, PositionHead, Position)