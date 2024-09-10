function intersection = find_intersection(Pin, Pout, Cin, Cout)
    % 获取每个点的坐标
    x1 = Pin(1); y1 = Pin(2);
    x2 = Pout(1); y2 = Pout(2);
    x3 = Cin(1); y3 = Cin(2);
    x4 = Cout(1); y4 = Cout(2);
    
    % 计算两条线段的参数
    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    
    % 如果 denom = 0，说明两条线段平行或共线
    if denom == 0
        intersection = [];  % 无交点（或共线的情况）
        return;
    end
    
    % 计算参数 t 和 u
    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom;
    u = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / denom;
    
    % 检查 t 和 u 是否在 [0, 1] 范围内，即交点是否在线段上
    if t >= 0 && t <= 1 && u >= 0 && u <= 1
        % 计算交点坐标
        x_intersect = x1 + t * (x2 - x1);
        y_intersect = y1 + t * (y2 - y1);
        intersection = [x_intersect, y_intersect];
    else
        intersection = [];  % 无交点，交点不在线段范围内
    end
end
