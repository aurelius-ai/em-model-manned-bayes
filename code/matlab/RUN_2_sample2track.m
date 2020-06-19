%% Inputs
% Input from RUN_1_emsample
% Also used here
model = 'uncor_v1p2';
d = '04-Mar-2020'; % date
num_files = 600;
parameters_filename = [getenv('AEM_DIR_BAYES') filesep 'model' filesep model '.txt'];

% Output from RUN_1_emsample
inDir = [getenv('AEM_DIR_BAYES') filesep 'output' filesep model filesep d];
initial_base = [inDir filesep model '_initial'];
transition_base =  [inDir filesep model '_transition'];

%% Create variables to measure performance
n_tracks = zeros(num_files,1);
run_time_s = zeros(num_files,1);

%% Iterate and Execute
parfor i=1:1:num_files
    tic;
    % Create filenames and directories
    initial_filename = [initial_base '_' num2str(i) '.txt'];
    transition_filename = [transition_base '_' num2str(i) '.txt'];
    out_dir_parent = [getenv('AEM_DIR_BAYES') filesep 'output' filesep 'tracks' filesep model '_' d filesep num2str(i)];
    
    % Execute
    [isGood,~] = sample2track(parameters_filename,initial_filename,transition_filename,...
        'out_dir_parent',out_dir_parent,...
        'rng_seed',i,...
        'isPlot',false);
    
    % Record performance
    n_tracks(i) = sum(isGood);
    runtime_s(i) = round(toc);
end

% Aggregate performance results into table
status = table(n_tracks,run_time_s);