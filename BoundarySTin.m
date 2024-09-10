function [flag] = BoundarySTin(x, y, PositionHead, Position)
    %% 板子变量
    weith = 0.3;
    side = 0.275;

    %% 计算顺序向量
    Coordinate = [PositionHead;Position];
    for i=1:1:length(Coordinate)-1
        TempVec = [Coordinate(i,1)-Coordinate(i+1,1),Coordinate(i,2)-Coordinate(i+1,2)];
        DirVector(i,:) = TempVec./norm(TempVec);
    end
    
    %% 计算所有前板点
    NormVector1 = [DirVector(:,2),-DirVector(:,1)];
    NormVector2 = [-DirVector(:,2),DirVector(:,1)];
    frountCoordinateR = Coordinate(1:end-1,:) + side.*DirVector + weith/2.*NormVector1;
    frountCoordinateL = Coordinate(1:end-1,:) + side.*DirVector + weith/2.*NormVector2;

    %% 计算所有后板点
    ConVector = -DirVector;
    NormVector1 = [ConVector(:,2),-ConVector(:,1)];
    NormVector2 = [-ConVector(:,2),ConVector(:,1)];
    backCoordinateL = Coordinate(2:end,:) + side.*ConVector + weith/2.*NormVector1;
    backCoordinateR = Coordinate(2:end,:) + side.*ConVector + weith/2.*NormVector2;

    %figure 
    plot(x, y,'LineWidth', 1);
    hold on
    scatter(Coordinate(:,1),Coordinate(:,2))
    % scatter(frountCoordinateR(:,1),frountCoordinateR(:,2))
    % scatter(frountCoordinateL(:,1),frountCoordinateL(:,2))
    % scatter(backCoordinateL(:,1),backCoordinateL(:,2))
    % scatter(backCoordinateR(:,1),backCoordinateR(:,2))
    for i=1:length(frountCoordinateR)
        plot([frountCoordinateR(i,1),backCoordinateR(i,1)],[frountCoordinateR(i,2),backCoordinateR(i,2)],'Color','r');
        plot([frountCoordinateL(i,1),backCoordinateL(i,1)],[frountCoordinateL(i,2),backCoordinateL(i,2)],'Color','r');
        plot([frountCoordinateR(i,1),frountCoordinateL(i,1)],[frountCoordinateR(i,2),frountCoordinateL(i,2)],'Color','r');
        plot([backCoordinateR(i,1),backCoordinateL(i,1)],[backCoordinateR(i,2),backCoordinateL(i,2)],'Color','r');
    end
    grid on;
    axis equal
    % legend('Curve','handle','frountCornerR','frountCornerL','backCornerL','backCornerR');

    %% 判断板点是否会与其他板碰撞
    % 这里只判断第一块板子的左侧两个点，是否会碰上
    DisMatrixFL=[10,10];
    DisMatrixBL=[10,10];
    for i=3:length(frountCoordinateR)
        DisMatrixFL(i) = sqrt((Coordinate(i,1) - frountCoordinateL(1,1))^2 + (Coordinate(i,2) - frountCoordinateL(1,2))^2);
        DisMatrixBL(i) = sqrt((Coordinate(i,1) - backCoordinateL(1,1))^2 + (Coordinate(i,2) - backCoordinateL(1,2))^2);
    end
    [~,minidxF] = min(DisMatrixFL);
    [~,minidxB] = min(DisMatrixBL);

    % 用判断函数，flag=1碰了/压线，flag=0没碰。
    % 判断左前点与最小点1的前后两块板是否碰，左后点与最小点2的前后两块板是否碰
    FlagsF1 = Checkforcoll(frountCoordinateL(1,:), Coordinate(minidxF,:), DirVector(minidxF,:), frountCoordinateR(minidxF,:));
    FlagsF2 = Checkforcoll(frountCoordinateL(1,:), Coordinate(minidxF,:), DirVector(minidxF-1,:), backCoordinateR(minidxF-1,:));
    FlagsB1 = Checkforcoll(backCoordinateL(1,:), Coordinate(minidxB,:), DirVector(minidxB,:), backCoordinateR(minidxB,:));
    FlagsB2 = Checkforcoll(backCoordinateL(1,:), Coordinate(minidxB,:), DirVector(minidxB-1,:), frountCoordinateR(minidxB-1,:));

    plot(frountCoordinateR(minidxF,1),frountCoordinateR(minidxF,2),'o','Color','g');
    plot(frountCoordinateR(minidxF-1,1),frountCoordinateR(minidxF-1,2),'o','Color','b');
    plot(backCoordinateR(minidxB,1),backCoordinateR(minidxB,2),'o','Color','g');
    plot(backCoordinateR(minidxB-1,1),backCoordinateR(minidxB-1,2),'o','Color','b');

    flag = FlagsF1+FlagsF2+FlagsB1+FlagsB2;
end

