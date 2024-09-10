clc
clear
close all

%% 螺线初始化
pitch = 2;
ratio = 1000000;
[x,y] = SpireCurve(pitch, ratio);

% 绘制螺旋线
figure;
plot(x, y,'LineWidth', 1.5,'Color','k');
axis equal;
set(gcf,'Position',[200 200 600 600]);
axis([-10 10 -10 10])