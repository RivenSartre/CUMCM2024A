function [xtotal,ytotal,half] = CreateTotalPath(pitch,r,ratio,interatio)
    %% 进入螺线初始化
    [x,y] = SpireCurve(pitch, ratio);
    
    % 找到切点
    radius = sqrt(x.^2 + y.^2);
    idx45 = find(radius<r,1);
    
    %% 中心对称一共退出螺线
    xm = -x;
    ym = -y;
    
    %% 中间的连接线
    Pin = [x(idx45), y(idx45)];
    Pout = [xm(idx45), ym(idx45)];
    
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
    
    interPoint = find_intersection(Pin, Pout, Cin, Cout);
    
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
    
    xtotal = [x(1:1:idx45)';xin';xout';xm(idx45:-1:1)'];
    ytotal = [y(1:1:idx45)';yin';yout';ym(idx45:-1:1)'];
    half = length(x(1:1:idx45)) + length(xin) + 1;
end