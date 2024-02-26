%
% sampling tree metric(s)
%

clear all
clc

nameDB = 'twitter';
fName = [nameDB '.mat'];

% noise l2 distance
% d --> d + delta
% delta = [-1, 1]*alpha
% alphaNoise = 0.1;

nTree = 1;

fNameOut = [nameDB '_Tree.mat'];

load(fName);
% XX: n x 1 cell 
% --- each cell: nw x d
% YY: n x 1 vector
% WW: n x 1 cell
% --- each cell: nw x 1 (count vector)

% normalize weights
for ii = 1:length(WW)
    WW{ii} = WW{ii}/sum(WW{ii});
end

% compute tree metric from input data
% then compute tree-Wasserstein (TW) distance matrix for the same input data

% parameter of tree metric
L = 6; % deepest level
KC = 4; % number of clusters for the farthest-point clustering

% for saving
% time
runTime_TM_array = zeros(nTree, 1);
runTime_REP_array = zeros(nTree, 1);
runTime_Tree_array = zeros(nTree, 1);
% data
TM_cell = cell(nTree, 1);
XX_TM_cell = cell(nTree, 1);

for iiTree = 1:nTree
    disp(['... Tree: #' num2str(iiTree)]);

    % building tree metric by the farthest-point clustering
    disp('...Computing the tree metric from input data');
    tic
    [TM, TX] = BuildTreeMetric_HighDim_V2(XX, L, KC);
    runTime_TM = toc;
    disp(['......running time: ' num2str(runTime_TM)]);
    
    disp('...Computing tree representation for input data');
    tic
    % mapping vector on tree
    XX_TM = zeros(length(XX), length(TM.Edge_Weight));
    for ii = 1:length(XX)
        % set of vertices of tree -- corresponding for probability XX
        XX_idVV = TX{ii};
% %         WW_idVV = WW{ii}/sum(WW{ii}); % normalization for WW
        WW_idVV = WW{ii};

        for jj = 1:length(XX_idVV)
            XX_TM(ii, TM.Vertex_EdgeIdPath{XX_idVV(jj)}) = XX_TM(ii, TM.Vertex_EdgeIdPath{XX_idVV(jj)}) + WW_idVV(jj);
        end
    end
    % % % weighted mapping
    % % XX_TMWW = XX_TM .* repmat(TM.Edge_Weight', length(XX), 1);
    runTime_REP = toc;
    disp(['......running time: ' num2str(runTime_REP)]);
    
    runTime_Tree = runTime_TM + runTime_REP;

    % saving
    runTime_TM_array(iiTree) = runTime_TM;
    runTime_REP_array(iiTree) = runTime_REP;
    runTime_Tree_array(iiTree) = runTime_Tree;

    TM_cell{iiTree} = TM;
    XX_TM_cell{iiTree} = XX_TM;
end

save(fNameOut, 'runTime_Tree_array', 'runTime_REP_array', 'runTime_TM_array', ...
    'TM_cell', 'XX_TM_cell', 'YY', 'WW');


disp('FINISH!');



