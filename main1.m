clc
clear
close all

%% 螺线初始化
pitch = 0.55;
ratio = 1000;
[x,y] = SpireCurve(pitch, ratio);

% 绘制螺旋线
figure;
plot(x, y,'o','LineWidth', 2);
grid on;
xlabel('X');
ylabel('Y');
title('Conical Helix');
axis equal;
hold on 

%% 算龙头坐标
Timelist = [0, 60, 120, 180, 240, 300];
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
PositionHead = [PositionHeadX', PositionHeadY'];

%% 算全身坐标
tableHead = 3.41 - 0.275*2;
tableBody = 2.20 - 0.275*2;

% tableHead = 0.1;
% tableBody = 0.1;

level = find(SpireLength>tableBody,1);
for Time = length(Timelist):-1:2
    % 算头
    tempLength = [];
    Position = [];
    for i = idx(Time):-1:1
        tempLength(i) = sqrt((x(i) - PositionHeadX(Time))^2 + (y(i) - PositionHeadY(Time))^2);
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
        k = k+1;
        jdxlist = [jdxlist, jdx];
    end
    
    plot(Position(:,1), Position(:,2),'o','color','g','LineWidth', 2);
    Cell_Position{Time-1} = [PositionHead(Time,:);Position];
    Cell_idx{Time-1} = [idx(Time),jdxlist];
end

%% 算全身线速度
% 算dts内，龙走了多少
dt = 0.1;
Timelist2 = Timelist + dt;
LengthHead2 = SpeedHead * Timelist2;
tempLength = [];
for i = 1:length(x)-1
    tempLength(i) = sqrt((x(i+1) - x(i))^2 + (y(i+1) - y(i))^2);
end
SpireLength2 = cumsum(tempLength);

for i = 1:length(Timelist2)
    idx(i) = find(SpireLength2 > LengthHead2(i),1);
end

PositionHeadX2 = x(idx);
PositionHeadY2 = y(idx);
PositionHead2 = [PositionHeadX2',PositionHeadY2'];

for Time = length(Timelist2):-1:2
    % 算头
    tempLength = [];
    Position = [];
    for i = idx(Time):-1:1
        tempLength(i) = sqrt((x(i) - PositionHeadX2(Time))^2 + (y(i) - PositionHeadY2(Time))^2);
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
        k = k+1;
        jdxlist = [jdxlist, jdx];
    end

    Cell_Position2{Time-1} = [PositionHead2(Time,:);Position];
    Cell_idx2{Time-1} = [idx(Time),jdxlist];
end

% 计算速度
for Time = length(Timelist):-1:2
    TempPosition = Cell_Position{Time-1};
    TempPosition2 = Cell_Position2{Time-1};
    distance_P2P = [];
    for i = 1:length(Cell_Position{Time-1})
        distance_P2P(i) = sqrt((TempPosition(i,1) - TempPosition2(i,1))^2 + (TempPosition(i,2) - TempPosition2(i,2))^2);
    end
    Velocitylist{Time-1} = distance_P2P / dt;
end
figure(2)
scatter(Cell_Position{1, 5}(:,1),Cell_Position{1, 5}(:,2))
hold on
scatter(Cell_Position2{1, 5}(:,1),Cell_Position2{1, 5}(:,2))
