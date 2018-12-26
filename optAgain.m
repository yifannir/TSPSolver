

%%
OptNum=40;
% routeOpt=route;
len=length(routeOpt);
for i =1:500
    tmpgroup_index=ceil(len*rand);
    if len-tmpgroup_index<OptNum
        tmpgroup_index=tmpgroup_index-OptNum;
    end
    tmpgroup = routeOpt(tmpgroup_index:tmpgroup_index+OptNum-1,:);
    [Road,Cost]=tspSolver(length(tmpgroup),1,length(tmpgroup),...
                                tmpgroup(:, 1),tmpgroup(:, 2)); 
    tmpgroup  =tmpgroup(Road,:);
    routeOpt(tmpgroup_index:(tmpgroup_index+OptNum-1),:)=tmpgroup;
    i
    if mod(i,50)==0
        save routeOpt;
    end
end

%%
costOpt=0;
for i =1:length(routeOpt)-1
    costOpt=costOpt + sqrt(sum((routeOpt(i,1:2)-routeOpt(i+1,1:2)).^2));
end

%%
% scatter(routeOpt(:, 1), routeOpt(:, 2))
% hold on;
% plot(routeOpt(:, 1), routeOpt(:, 2))