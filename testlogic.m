%%
% clear all, clc, close all

global ROUTE
global cityCell
global COST
global topFlag

cityCell={};
ROUTE = [];
COST = 0;
topFlag=1;
NUM_TYPES = 4;
scale = 5; pm = 10; genrd = 30;
swarm = genData(genrd, scale, pm);

% swarm = 100*rand(nSizeIn, 2);
swarm = [swarm, (1:length(swarm))']; % this is the original ids
swarm = ja9847;
% viewSwarm(swarm(:, 1), swarm(:, 2), lbl)

layer = swarm;
tmpCenters = zeros(length(layer), 1);
% calc a list centers of all the subsets, for linprog of current
% layer
if iscell(layer)
    for k = 1:numel(layer)
        tmpCenters(k) = [mean(layer{k}(:, 1:2)), layer{k}(:, 3)]; % layer{k} must be col vector
    end
else % input data, as a single vector
    tmpCenters = layer;
end
[nxtIdx, Centr] = kmeans(tmpCenters(:, 1:2), NUM_TYPES, 'Distance','sqeuclidean',...
            'Replicates',10,'Options',statset('Display','final'));

%%
logicImp(swarm, NUM_TYPES,100);

%%
figure(221)


route = [];
for i =1:length(cityCell)
    route=[route;cityCell{i}];
end
MarkSwarm(route(:, 1:2), Centr, nxtIdx, 'k', 'v', 8)

hold on;
plot(route(:, 1), route(:, 2))
