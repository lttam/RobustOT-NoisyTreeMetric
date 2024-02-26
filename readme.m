
% This is the code for the paper
% Title: "Optimal Transport for Measures with Noisy Tree Metric"
% Authors: Tam Le, Truyen Nguyen, Kenji Fukumizu
% Published at AISTATS 2024

% ***** Data: e.g., 'twitter.mat' for the TWITTER dataset
% Please see: https://github.com/lttam/SobolevTransport (for the dataset
% 'twitter.mat'


% --- third-party toolbox for tree-Wasserstein (in LibTW folder)
% addPath.m : to set path for the LibTW folder


% Step 1: Build tree metric
% -- compute_Tree_Representation.m


% Step 2: Generate perturbation
% -- compute_Tree_Noise.m


% Step 3: Compute max-min robust OT for measures with tree metric

% --- For constraints on individual edges ---
% For local approach: compute_RobustOT_Local.m

% --- For constraints on set of edges ---
% For global approach: compute_RobustOT_Global.m



