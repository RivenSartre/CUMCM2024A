clc
clear
close all

%% 螺线初始化
pitch = 0.4133333;
ratio = 1000000;
[x,y] = SpireCurve(pitch, ratio);
r = 4.5;

% % 绘制螺旋线
% figure(1);
% rectangle('Position', [0 - r, 0 - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', 'b','FaceColor','y', 'LineWidth', 1.2);
% hold on
% grid on;
% plot(x, y,'LineWidth', 2);
% xlabel('X');
% ylabel('Y');
% title('Conical Helix');
% axis equal;
% hold on 

radius = sqrt(x.^2 + y.^2);
idx45 = find(radius<4.5,1);
tangPoint = [x(idx45),y(idx45)];

[R, Rerror] = CalcuTheRoC(x,y,idx45,r)

%% 计算身体
tempLength = [];
for i = 1:length(x)-1
    tempLength(i) = sqrt((x(i+1) - x(i))^2 + (y(i+1) - y(i))^2);
end
SpireLength = cumsum(tempLength);

PositionHeadX = x(idx45);
PositionHeadY = y(idx45);
PositionHead = [PositionHeadX',PositionHeadY'];

% 算全身坐标
tableHead = 3.41 - 0.275*2;
tableBody = 2.20 - 0.275*2;

level = find(SpireLength>tableBody,1);
% 算头
tempLength = [];
Position = [];
for i = idx45:-1:1
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

[flag] = BoundarySTin(x, y, PositionHead, Position)

