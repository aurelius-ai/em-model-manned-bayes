% Copyright 2008 - 2020, MIT Lincoln Laboratory
% SPDX-License-Identifier: BSD-2-Clause
%% Inputs
inDir = [getenv('AEM_DIR_BAYES') filesep 'model'];
model = 'uncor_1200code_v2p1'; % the name of the parameters file

outDir = [getenv('AEM_DIR_BAYES') filesep 'output' filesep model filesep date];

num_initial_samples = 10; % number of samples to generate
num_transition_samples = 160; % the number of steps to sample from the transition network

% For loading balancing, don't write all samples to a single file
max_samples_perfile = 25000; % Maximum number of samples per file

isOverwriteZeroBoundaries = false; % If true, sample bins index and not return a numeric sampled value
idxZeroBoundaries = [1 2 3]; % Index of parameters.boundaries to force to be zero / empty

%% Make sure system environment variable is set
if isempty(getenv('AEM_DIR_BAYES'))
    error('AEM_DIR_BAYES:notset','System environment variable AEM_DIR_BAYES has not been set');
end

%% Calculate number of files needed
if num_initial_samples <= max_samples_perfile
    num_files = 1;
    num_samples_perfiles = num_initial_samples;
else
    num_files = ceil(num_initial_samples / max_samples_perfile);
    num_samples_perfiles = ceil(num_initial_samples / num_files);
end

%% Make output directory
if exist(outDir,'dir') ~= 7; mkdir(outDir); end

%% Execute
for i=1:1:num_files
    em_sample([inDir filesep model '.txt'],...
        'initial_output_filename',[outDir filesep model '_initial' '_' num2str(i) '.txt'],...
        'transition_output_filename',[outDir filesep model '_transition' '_' num2str(i) '.txt'],...
        'num_initial_samples',num_samples_perfiles,...
        'num_transition_samples',num_transition_samples,...
        'isOverwriteZeroBoundaries',isOverwriteZeroBoundaries,...
        'idxZeroBoundaries',idxZeroBoundaries,...
        'rng_seed',i);
end
