% This function is part of the isoMuSh algorithm for the coorespondence 
% estimation of isometric shape collection, as described in [1]. When you
% use this code, you are required to cite [1].
% 
% [1] Isometric Multi-Shape Matching
% Author: M. Gao, Z. Lähner, J. Thunberg, D. Cremers, F. Bernard.
% IEEE Conference on Computer Vision and Pattern Recognition 2021 (CVPR 2021)
%
% 
% Author & Copyright (C) 2021: Maolin Gao (maolin.gao[at]gmail[dot]com)
%
%
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as published
% by the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Affero General Public License for more details.

% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function data = load_dataset(params)

data = [];

try
    rootpath = params.rootpath;
    verbose = params.verbose;
    datasetname = params.datasetname;
    dataname = params.dataname;
    
catch ME
    
    fprintf('** Fail to parse params! **\n');
    rethrow(ME)
end

datafullname = strcat(dataname, '.mat');


try
    datafullpath = fullfile(rootpath, 'data', datasetname, datafullname);
    % disp(datafullpath);
    % load(datafullpath, 'S', 'S_map');
    n = 27;
    S = cell(n, 1);
    S_map = cell(n, 1);
    load('/mnt/xrhuang/isomush/data/faust/0.mat', 'Si', 'S_map_i');
    S{1} = Si;
    S_map{1} = S_map_i;
    data_id = str2num(dataname);
    for j = 1:(n-1)
      i = data_id*(n-1) + j + 1;
      name = num2str(i-1);
      load(strcat(['/mnt/xrhuang/isomush/data/faust/', name, '.mat']), 'Si', 'S_map_i');
      S{j+1} = Si;
      S_map{j+1} = S_map_i;
    end
catch ME
    fprintf('Fail to load dataset (*.mat)!\n');
    fprintf('Revert to load the original dataset (*.off, *.ply etc)!\n');
    
    [S, S_map] = load_dataset_origFormat(params);
    
end

numShape = length(S);
assert(numShape > 1);
dimLB = size(S{1}.origRes.evecs, 2); % the total number of precomputed eigenfunctions


dimVector = nan(numShape,1);
phicell = cell(numShape,1);
for i = 1 : numShape
  Si = subsample_shape(S{i});
  dimVector(i) = Si.nv;
  phicell{i} = Si.evecs;
end

data.S = S;
data.S_map = S_map;
data.dimVector = dimVector;
data.numShape = numShape;
data.dimLB = dimLB;
data.phicell = phicell;


end
