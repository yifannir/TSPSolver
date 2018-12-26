function [road,cost]=tspSolver(nStops,startNode,endNode,stopsLon,stopsLat)

if nStops==1
    road=zeros(1,1);
    road(1)=1;
    cost=0;
    return;
end
%增加一个虚拟节点

nStops = nStops+1; % you can use any number, but the problem size scales as N^2
virtualX = stopsLon(1,1)+rand;
virtualY = stopsLat(1,1)+rand;
stopsLon=[stopsLon;virtualX];
stopsLat=[stopsLat;virtualY];
virtualNode=nStops;

idxs = nchoosek(1:nStops,2);
[idxs_x,idxs_y]=size(idxs);

dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
             stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));
lendist = length(dist);

%%%%%%%%增加虚拟节点，修改距离矩阵%%%%%%%%%%%
for i=1:length(idxs)
    if idxs(i,1)==virtualNode
        dist(i)=1e10;
    end
    if idxs(i,2)==virtualNode
        dist(i)=1e10;
    end
    if idxs(i,1)==virtualNode && idxs(i,2)==startNode
        dist(i)=0;
    end
    if idxs(i,2)==virtualNode && idxs(i,1)==startNode
        dist(i)=0;
    end
    if idxs(i,1)==virtualNode && idxs(i,2)==endNode
        dist(i)=0;
    end
    if idxs(i,2)==virtualNode && idxs(i,1)==endNode
        dist(i)=0;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = nStops;

Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))]; % allocate a sparse matrix
for ii = 1:nStops
    whichIdxs = (idxs == ii); % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];

intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);

opts = optimoptions('intlinprog','Display','off','Heuristics','round-diving',...
    'IPPreprocess','none');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(nStops,1); % Use to store handles to lines on plot
lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours

A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour

    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour

        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    % Visualize result
    lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
end

tours = detectSubtours(x_tsp,idxs);
%%%%%%%%%%%%处理虚拟节点，将闭源路径转化为开源路径%%%%%%%%%
roadtmp=tours{1};
virtualID=0;
startID=0;
endID=0;
roadCity=nStops-1;
road=zeros(roadCity,1);
for i=1:length(roadtmp)
    if(roadtmp(i)==virtualNode)
        virtualID=i;
    end
    if(roadtmp(i)==startNode)
        startID=i;
    end
    if(roadtmp(i)==endNode)
        endID=i;
    end
end
road(1:nStops-virtualID) = roadtmp(virtualID+1:nStops);
road(nStops-virtualID+1:roadCity) = roadtmp(1:virtualID-1);
if startID<endID
    road=flipud(road);
end
cost = costopt;

end