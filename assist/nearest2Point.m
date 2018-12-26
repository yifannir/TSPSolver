function [Idx] = nearest2Point(IdxToDeleteFrom1, data1, data2)
    [data1_x,data1_y]=size(data1);
    [data2_x,data2_y]=size(data2);
    mindis = inf;
    Idx = [1 1];
    for k1 = 1 : data1_x
        pt1 = data1(k1, 1:2);
        for k2 = 1:data2_x
            pt2 = data2(k2, 1:2);
            disthis = sum((pt1 - pt2).^2);
            if disthis < mindis && Idx(1) ~= IdxToDeleteFrom1 
                mindis = disthis;
                Idx(2) = k2;
                Idx(1) = k1;
            end
        end
    end
    [data1_x,data1_y]=size(data1);
    [data2_x,data2_y]=size(data2);
    if data1_x == 1
       Idx(1) = 1; 
    end
    if data2_x == 1
       Idx(2) = 1; 
    end
    
end