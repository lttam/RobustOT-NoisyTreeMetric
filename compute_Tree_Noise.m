%
% generative noise for tree metric(s)
%

clear all
clc

nameDB = 'twitter';
fName = [nameDB '_Tree.mat'];

% noise l2 distance
% d --> d + delta
% delta = [-1, 1]*alpha
alphaNoise = 0.5;

fNameOut = [nameDB '_TreeNoise' num2str(alphaNoise) '.mat'];

load(fName);
% runTime_REP/TM/Tree_array
% TM_cell: ntr x 1 cell
% WW: n x 1 cell (normalized)
% XX_TM_cell: ntr x 1 cell
% YY: n x 1

nTree = length(TM_cell);
noise_matrix_cell = cell(nTree, 1);

for ii = 1:nTree

    TM = TM_cell{ii};
    WW_Edge = repmat(TM.Edge_Weight', length(YY), 1);
    noise_matrix = (rand(size(WW_Edge))*2 - 1)*alphaNoise; % [-1, 1]*alpha

    % saving
    noise_matrix_cell{ii} = noise_matrix;
end

save(fNameOut, 'noise_matrix_cell', '-v7.3');

disp('FINISH !!!');




