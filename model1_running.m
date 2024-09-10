clc
clear
close all
%% 螺旋线初始化
pitch = 1.7;
ratio = 1000000;
interatio = 100000;
r =2.0;

[x,y,half] = CreateTotalPath(pitch,r,ratio,interatio);

% 绘制螺旋线
figure(1);
h = plot(x, y,'LineWidth', 2);
grid on;
xlabel('X');
ylabel('Y');
title('Conical Helix');
axis equal;
hold on 

%% 模拟行进
Timelist =150;

for Timelist = 148:0.2:153
    clf;
        
    SpeedHead = 1;
    LengthHead = SpeedHead * Timelist;
    tempLength = [];
    for i = 1:length(x)-1
        tempLength(i) = sqrt((x(i+1) - x(i))^2 + (y(i+1) - y(i))^2);
    end
    SpireLength = cumsum(tempLength);
    
    idx = find(SpireLength > LengthHead,1);
    plot(x(idx), y(idx),'o','color','r', 'LineWidth', 2);
    text(x(idx)+0.5, y(idx)+0.5, num2str(Timelist));
    
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
        jdx = length(Distance_H2P)-find(Distance_H2P > tableBody,1)+1;
        Position(k+1,:) = [x(jdx), y(jdx)];
        if k > 220
            break
        end
        k = k+1;
        jdxlist = [jdxlist, jdx];
    end
    plot(Position(:,1), Position(:,2),'o','color','g','LineWidth', 2);

    [Inflag] = BoundarySTin(x, y, PositionHead, Position);
    pause(0.01);
end