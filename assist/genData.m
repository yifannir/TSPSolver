function data = genData(n, scale, pm)
    data = [];
    for k  = 1:n
        ss =randi(scale*pm);
        tmp = randi(scale)*randn(ss, 2);
        tmp(:,1) = tmp(:,1) + randi(scale*pm);
        tmp(:,2) = tmp(:,2) + randi(scale*pm);
%         tmp = [tmp, k*ones(ss, 1)];
        data = [data; tmp];
    end
end