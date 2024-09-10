function [FlagCollies] = Checkforcoll(point1, point2, vector, node)
    A = -vector(2);
    B = vector(1);
    C = vector(2)*node(1) - node(2)*vector(1);
    
    % 计算两点到直线的符号距离
    f1 = A * point1(1) + B * point1(2) + C;
    f2 = A * point2(1) + B * point2(2) + C;
    
    % 判断两点是否在直线同侧
    if f1 * f2 > 0          % 同侧
        FlagCollies = 1;
    elseif f1 * f2 < 0      % 不同侧
        FlagCollies = 0;    
    else                    % 压线，视为同侧
        FlagCollies = 1;
    end

end
