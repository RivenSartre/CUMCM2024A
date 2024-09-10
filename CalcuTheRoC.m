function [R, Rerror] = CalcuTheRoC(x,y,idx45,r)
    P1 = [x(idx45-1), y(idx45-1)];
    P2 = [x(idx45), y(idx45)];
    P3 = [x(idx45+1), y(idx45+1)];
    
    d1 = sqrt((P2(1) - P1(1))^2 + (P2(2) - P1(2))^2);
    d2 = sqrt((P3(1) - P2(1))^2 + (P3(2) - P2(2))^2);
    d3 = sqrt((P3(1) - P1(1))^2 + (P3(2) - P1(2))^2);
    
    A = 0.5 * abs(P1(1)*(P2(2) - P3(2)) + P2(1)*(P3(2) - P1(2)) + P3(1)*(P1(2) - P2(2)));
    
    if A ~= 0
        R = (d1 * d2 * d3) / (4 * A);
    else
        R = Inf;  % 如果三点共线，曲率半径为无穷大
    end

    Rerror = r - R;
end