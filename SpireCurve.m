function [x,y] = SpireCurve(pitch,ratio)
k = - pitch/2/pi;     % 半径增长速率
t = linspace(0, 8.8*2*pi/pitch, ratio);  % 参数t的范围，生成10圈
x = (8.8 + k * t) .* cos(t);
y = -(8.8 + k * t) .* sin(t);
end

