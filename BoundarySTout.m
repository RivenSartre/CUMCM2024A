function [flag] = BoundarySTout(x, y, PositionHead, Position)
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

    figure 
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
    % 这里判断第一块板子的左侧两个点，是否会碰上
    DisMatrixFL=[10,10,10,10,10];
    DisMatrixBL=[10,10,10,10,10];
    DisMatrixFR=[10,10,10,10,10];
    DisMatrixBR=[10,10,10,10,10];
    for i=5:length(frountCoordinateR)
        DisMatrixFL(i) = sqrt((Coordinate(i,1) - frountCoordinateL(1,1))^2 + (Coordinate(i,2) - frountCoordinateL(1,2))^2);
        DisMatrixFR(i) = sqrt((Coordinate(i,1) - frountCoordinateR(1,1))^2 + (Coordinate(i,2) - frountCoordinateR(1,2))^2);
        DisMatrixBL(i) = sqrt((Coordinate(i,1) - backCoordinateL(1,1))^2 + (Coordinate(i,2) - backCoordinateL(1,2))^2);
        DisMatrixBR(i) = sqrt((Coordinate(i,1) - backCoordinateR(1,1))^2 + (Coordinate(i,2) - backCoordinateR(1,2))^2);
    end
    [~,minidxFL] = min(DisMatrixFL);
    [~,minidxBL] = min(DisMatrixBL);
    [~,minidxFR] = min(DisMatrixFR);
    [~,minidxBR] = min(DisMatrixBR);

    % 用判断函数，flag=1碰了/压线，flag=0没碰。
    % 判断左前点与最小点1的前后两块板是否碰，左后点与最小点2的前后两块板是否碰
    FlagsFl1 = Checkforcoll(frountCoordinateL(1,:), Coordinate(minidxFL,:), DirVector(minidxFL,:), frountCoordinateL(minidxFL,:));
    FlagsFl2 = Checkforcoll(frountCoordinateL(1,:), Coordinate(minidxFL,:), DirVector(minidxFL-1,:), backCoordinateL(minidxFL-1,:));
    FlagsBl1 = Checkforcoll(backCoordinateL(1,:), Coordinate(minidxBL,:), DirVector(minidxBL,:), backCoordinateL(minidxBL,:));
    FlagsBl2 = Checkforcoll(backCoordinateL(1,:), Coordinate(minidxBL,:), DirVector(minidxBL-1,:), frountCoordinateL(minidxBL-1,:));

    % 用判断函数，flag=1碰了/压线，flag=0没碰。
    % 判断左前点与最小点1的前后两块板是否碰，左后点与最小点2的前后两块板是否碰
    FlagsFr1 = Checkforcoll(frountCoordinateR(1,:), Coordinate(minidxFR,:), DirVector(minidxFR,:), frountCoordinateR(minidxFR,:));
    FlagsFr2 = Checkforcoll(frountCoordinateR(1,:), Coordinate(minidxFR,:), DirVector(minidxFR-1,:), backCoordinateR(minidxFR-1,:));
    FlagsBr1 = Checkforcoll(backCoordinateR(1,:), Coordinate(minidxBR,:), DirVector(minidxBR,:), backCoordinateR(minidxBR,:));
    FlagsBr2 = Checkforcoll(backCoordinateR(1,:), Coordinate(minidxBR,:), DirVector(minidxBR-1,:), frountCoordinateR(minidxBR-1,:));

    plot(frountCoordinateR(minidxFR,1),frountCoordinateR(minidxFR,2),'o','Color','g');
    text(frountCoordinateR(minidxFR,1),frountCoordinateR(minidxFR,2),'1');
    plot(frountCoordinateR(minidxFR-1,1),frountCoordinateR(minidxFR-1,2),'o','Color','b');
    text(frountCoordinateR(minidxFR-1,1),frountCoordinateR(minidxFR-1,2),'2');
    plot(backCoordinateR(minidxBR,1),backCoordinateR(minidxBR,2),'o','Color','g');
    text(backCoordinateR(minidxBR,1),backCoordinateR(minidxBR,2),'3');
    plot(backCoordinateR(minidxBR-1,1),backCoordinateR(minidxBR-1,2),'o','Color','b');
    text(backCoordinateR(minidxBR-1,1),backCoordinateR(minidxBR-1,2),'4');

    plot(frountCoordinateL(minidxFL,1),frountCoordinateL(minidxFL,2),'o','Color','r');
    text(frountCoordinateL(minidxFL,1),frountCoordinateL(minidxFL,2),'5');
    plot(frountCoordinateL(minidxFL-1,1),frountCoordinateL(minidxFL-1,2),'o','Color','y');
    text(frountCoordinateL(minidxFL-1,1),frountCoordinateL(minidxFL-1,2),'6');
    plot(backCoordinateL(minidxBL,1),backCoordinateL(minidxBL,2),'o','Color','r');
    text(backCoordinateL(minidxBL,1),backCoordinateL(minidxBL,2),'7');
    plot(backCoordinateL(minidxBL-1,1),backCoordinateL(minidxBL-1,2),'o','Color','y');
    text(backCoordinateL(minidxBL-1,1),backCoordinateL(minidxBL-1,2),'8');

    flag = FlagsFl1+FlagsFl2+FlagsBl1+FlagsBl2 +FlagsFr1+FlagsFr2+FlagsBr1+FlagsBr2;
end

