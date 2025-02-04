
function zoom_out(split1, split2)
% demo: faust 1st person
%
restoredefaultpath
addpath(genpath('./code'))
addpath(genpath('./eval'))

%% choose shape collection
% For the 1st FAUST person we provide the original *.ply and the corresponding
% preprocessed *.mat files used in our pipeline for demo purpose.
% To experiment with other shape collections, please download the original
% FAUST dataset, and adapt params.dataPreparation.datapath_orig.

datasetname = 'faust';
dataname = '0'; % {'0' - '9'}
params.dataPreparation.datapath_orig = '/mnt/xrhuang/datasets/dfaust1k_test/ply_orig'; %'<ROOT_TO_FAUST_PLY_FILES>';


%% safe to ignore

params.verbose = 2;
params.isomush.maxIter = 1e2;
numFace = 2e3;
dimLB = 100;

%% do not touch
params.rootpath = pwd;
params.datasetname = datasetname;
params.dataname = dataname;
params.dataPreparation.dimLB = dimLB;
params.dataPreparation.numFace = numFace;
params.dataPreparation.datapath_mat = fullfile(params.rootpath, 'data', datasetname, 'mat_orig');

%%
% load dataset
fprintf('loading (%s, %s)... \n', datasetname, dataname);
data = load_dataset(params, split1, split2);

% initialisation
% -- ZoomOut --
fprintf('\nInitialisation...\n')
fprintf('\n1) Running ZoomOut for all pairs on (%s, %s)... \n', datasetname, dataname);
[C, C_map, T, T_map, time_zoomout] = zoomout_wrapper(data, params, split1, split2);

end
