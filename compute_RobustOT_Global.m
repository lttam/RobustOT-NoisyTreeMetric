%
% --- For constraints on set of edges ---
% compute the max-min robust OT
%

clear all
clc

% num_th=maxNumCompThreads(50);

nameDB = 'twitter';
fName = [nameDB '_Tree.mat'];

% noise l2 distance
% d --> d + delta
% delta = [-1, 1]*alpha
alphaNoise = 0.5;

fNameNoise = [nameDB '_TreeNoise' num2str(alphaNoise) '.mat'];
load(fNameNoise);
% noise_matrix_cell

alphaInterval = 5;

distanceName = 'RT_Global'; %l2 cost matrix
fNameOut = [nameDB num2str(alphaNoise) '_DM_' distanceName num2str(alphaInterval) '.mat'];

load(fName);
% runTime_REP/TM/Tree_array
% TM_cell: ntr x 1 cell
% WW: n x 1 cell (normalized)
% XX_TM_cell: ntr x 1 cell
% YY: n x 1

% potential for many trees
nTree = length(TM_cell);
DD_XX_cell = cell(nTree, 1);
runTime_RT_array = zeros(nTree, 1);

for iiTree = 1:nTree

    disp(['... Tree: #' num2str(iiTree)]);

    % compute tree metric from input data
    % then compute tree-Wasserstein (TW) distance matrix for the same input data
    
    % building tree metric by the farthest-point clustering
    % mapping vector on tree
    TM = TM_cell{iiTree};
    XX_TM = XX_TM_cell{iiTree};
    
    % % weighted mapping
    WW_Edge = repmat(TM.Edge_Weight', length(YY), 1);

    % using the same noise 
    noise_matrix = noise_matrix_cell{iiTree};
    % noise on L2 distance (edge weight)
    WW_Edge_noise = WW_Edge + noise_matrix;
    WW_Edge_noise = max(0, WW_Edge_noise);

    disp('...Computing robust TW (ball)');
    
    tic
    % for L1-part
    XX_TMWW = XX_TM .* WW_Edge_noise; % noise on L2 distance (edge)
    % for L2-part
    % XX_TM

    % compute TW distance matrix for XX
    % L1 distance
    DD_XX = zeros(length(YY), length(YY));
    
    for ii = 1:(length(YY)-1)

        if mod(ii, 100) == 0
            disp(['...' num2str(ii)]);
        end

        % L1 distances between ii^th id and (ii+1 : length(XX))^th ids
        % XX_TMWW
        tmp = sum(abs(repmat(XX_TMWW(ii, :), length(YY) - ii, 1) - XX_TMWW((ii+1):length(YY), :)), 2);

        % L2-part
        % XX_TM
        l2_tmp_diff = abs(repmat(XX_TM(ii, :), length(YY) - ii, 1) - XX_TM((ii+1):length(YY), :));
        l2_tmp_sqr = l2_tmp_diff .* l2_tmp_diff;
        l2_tmp_sum = sum(l2_tmp_sqr, 2);
        l2_tmp = sqrt(l2_tmp_sum);

        DD_XX(ii, (ii+1):length(YY)) = tmp' + alphaInterval*l2_tmp';
        DD_XX((ii+1):length(YY), ii) = tmp + alphaInterval*l2_tmp;
    end
    runTime_TW = toc;
    disp(['......running time: ' num2str(runTime_TW)]);


    % saving
    DD_XX_cell{iiTree} = DD_XX;
    runTime_RT_array(iiTree) = runTime_TW;

end

% all_runTime
runTime_ALL = runTime_RT_array + runTime_Tree_array;

% 1 Tree
DD_XX1 = DD_XX_cell{1};

% runTime_REP/TM/Tree_array
% TM_cell: ntr x 1 cell
% WW: n x 1 cell (normalized)
% XX_TM_cell: ntr x 1 cell
% YY: n x 1

save(fNameOut, 'DD_XX1', ...
    'YY', 'runTime_RT_array', 'runTime_REP_array', ...
    'runTime_TM_array', 'runTime_Tree_array', 'runTime_ALL');

disp('FINISH!');



