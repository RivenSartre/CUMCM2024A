function [diffs, exceed] = check_differences(sequence, limit)
    % 计算序列的差分
    diffs = diff(sequence);
    
    % 检查差分是否超过限定值
    exceed = abs(diffs) > limit;
    
    % 打印差分和超出限定值的标志
    %disp('差分：');
    %disp(diffs);
    
    disp('差分是否超过限定值：');
    disp(sum(exceed));
end