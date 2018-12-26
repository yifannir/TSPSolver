function [idx] = nearestPoint(data1, data2)

    [data1_x,data1_y]=size(data1);
    [data2_x,data2_y]=size(data2);
    mindis = inf;
    for k1 = 1 : data1_x
        pt1 = data1(k1, 1:2);
        for k2 = 1:data2_x
            pt2 = data2(k2, 1:2);
            disthis = sum((pt1 - pt2).^2);
            if disthis < mindis
                mindis = disthis;
                idx(2) = k2;
                idx(1) = k1;
            end
        end
    end
end