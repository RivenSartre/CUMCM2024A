clc
clear
close all

%% 进入螺线初始化
pitch = 1.7;
ratio = 10000000;
interatio = 1000000;
[x,y] = SpireCurve(pitch, ratio);

% 找到切点
r =2.0;
radius = sqrt(x.^2 + y.^2);
idx45 = find(radius<r,1);
tangPoint = [x(idx45),y(idx45)];
[R, Rerror] = CalcuTheRoC(x,y,idx45,r);
% 绘制螺旋线
figure(1);
plot(x(1:idx45), y(1:idx45),'LineWidth', 2);
grid on;
xlabel('X');
ylabel('Y');
title('Conical Helix');
axis equal;
hold on 

%% 中心对称一共退出螺线
xm = -x;
ym = -y;

% 绘制螺旋线
plot(xm(1:idx45), ym(1:idx45),'LineWidth', 2);

%% 中间的连接线
Pin = [x(idx45), y(idx45)];
Pout = [xm(idx45), ym(idx45)];
plot(Pin(1), Pin(2),'o','LineWidth', 2);
plot(Pout(1), Pout(2),'o','LineWidth', 2);

DirVectorin = [x(idx45+1)-x(idx45), y(idx45+1)-y(idx45)];
DirVectorout = [xm(idx45+1)-xm(idx45), ym(idx45+1)-ym(idx45)];

StringVector = Pout - Pin;
StringVectorCon = Pin - Pout;

NormVectorin = [DirVectorin(2), -DirVectorin(1)];
NormVectorout = [DirVectorout(2), -DirVectorout(1)];

NormVectorin = NormVectorin/norm(NormVectorin);
NormVectorout = NormVectorout/norm(NormVectorout);

String = norm(StringVector);
Stringin = 2/3 * String /2;
Stringout = 1/3 * String /2;

thetain = acos(dot(DirVectorin, StringVector)/ (norm(StringVector) * norm(DirVectorin)));
thetaout = acos(dot(DirVectorout, StringVectorCon)/ (norm(StringVectorCon) * norm(DirVectorout)));

Rin = Stringin / cos(pi/2 - thetain);
Rout = Stringout / cos(pi/2 - thetaout);

Cin = Pin + NormVectorin * Rin;
Cout = Pout + NormVectorout * Rout;
plot(Cin(1), Cin(2),'o','LineWidth', 2);
plot(Cout(1), Cout(2),'o','LineWidth', 2);

legend
interPoint = find_intersection(Pin, Pout, Cin, Cout);
plot(interPoint(1), interPoint(2),'o','LineWidth', 2);

% 计算两个端点之间的角度
thetain1 = atan2(Pin(2) - Cin(2), Pin(1) - Cin(1)) ;
thetain2 = atan2(interPoint(2) - Cin(2), interPoint(1) - Cin(1)) ;
thetaout1 = atan2(Pout(2) - Cout(2), Pout(1) - Cout(1));
thetaout2 = atan2(interPoint(2) - Cout(2), interPoint(1) - Cout(1));

if -pi/2<= thetain1 && thetain1< 0  % 入点第四象限.
    if -pi<= thetain2 && thetain2< -pi/2 % 转弯第三象限
        Thetain = linspace(thetain1, thetain2 , interatio); % 100个点的角度
        Thetaout = linspace(thetaout2, thetaout1, interatio); % 100个点的角度
    else 
        Thetain = linspace(thetain1+ 2*pi, thetain2,  interatio); % 100个点的角度
        Thetaout = linspace(thetaout2, thetaout1, interatio); % 100个点的角度
    end
elseif 0<= thetain1 && thetain1< pi/2  % 入点第一象限.
    Thetain = linspace(thetain1, thetain2, interatio); % 100个点的角度
    Thetaout = linspace(thetaout2, thetaout1 + 2*pi, interatio); % 100个点的角度
elseif  pi/2<= thetain1 && thetain1< pi  % 入点第二象限.
    Thetain = linspace(thetain1, thetain2, interatio); % 100个点的角度
    Thetaout = linspace(thetaout2, thetaout1 + 2*pi, interatio); % 100个点的角度
    if -pi<= thetaout2 && thetaout2< -pi/2 % 出点第三象限
        Thetain = linspace(thetain1, thetain2 , interatio); % 100个点的角度
        Thetaout = linspace(thetaout2, thetaout1 , interatio); % 100个点的角度
    end
else   
    Thetain = linspace(thetain1+ 2*pi, thetain2 , interatio); % 100个点的角度
    Thetaout = linspace(thetaout2, thetaout1, interatio); % 100个点的角度

end

% 计算半圆上每个点的坐标
xin = Cin(1) + Rin * cos(Thetain);
yin = Cin(2) + Rin * sin(Thetain);

xout = Cout(1) + Rout * cos(Thetaout);
yout = Cout(2) + Rout * sin(Thetaout);

plot(xin, yin, '-', 'LineWidth', 2); % 半圆弧
plot(xout, yout, '-', 'LineWidth', 2); % 半圆弧

xtotal = [x(1:1:idx45)';xin';xout';xm(idx45:-1:1)'];
ytotal = [y(1:1:idx45)';yin';yout';ym(idx45:-1:1)'];
figure
plot(xtotal);
hold on
plot(ytotal);
[~, Xexceed] = check_differences(xtotal, 0.01);
[~, Yexceed] = check_differences(xtotal, 0.01);

%% 计算弧长
tempLength = [];
for i = 1:length(xin)-1
    tempLength(i) = sqrt((xin(i+1) - xin(i))^2 + (yin(i+1) - yin(i))^2);
end
Lengthin = cumsum(tempLength);

tempLength = [];
for i = 1:length(xout)-1
    tempLength(i) = sqrt((xout(i+1) - xout(i))^2 + (yout(i+1) - yout(i))^2);
end
Lengthout = cumsum(tempLength);


SpringLength = Lengthout(end) + Lengthin(end);


A = diff(xtotal);
B = diff(ytotal);

figure
plot(A);
hold on
plot(B);