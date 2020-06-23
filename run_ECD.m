clear all;
clc;

%% Load a dataset
flag = 2;  % set flag = 1 for synthetic networks or flag = 2 for real-world networks
% synthetic networks
% load('datasets/syn_fix_3.mat');
% load('datasets/syn_fix_5.mat');
% load('datasets/syn_var_3.mat');
% load('datasets/syn_var_5.mat');
% load('datasets/expand.mat');
% load('datasets/mergesplit.mat');

% real-world networks
% the gound truth community structures are returned by the first step of DYNMOGA
% load('datasets/cell.mat');
% load('datasets/firststep_DYNMOGA_cell.mat');
load('datasets/enron.mat');
load('datasets/firststep_DYNMOGA_enron.mat');
GT_Cube = dynMoeaResult;

%% Parameter setting
maxgen = 100;         % the maximum number of iterations
pop_size = 100;       % the population size
num_neighbor = 10;    % the neighbor size for each subproblem
p_mutation = 0.20;    % the mutation rate
p_migration = 0.50;   % the migration rate
p_mu_mi = 0.50;       % the paramater to control the execution of mutation and migration
Threshold = 0.80;     % R=1-Threshold is the parameter related to pupulation generation   
num_repeat = 5;       % the number of repeated run


%% Results at each time step
dynMod = [];          % modularity of detected community structure
dynNmi = [];          % NMI between detected community structure and the ground truth
dynPop = {};          % the population
dynTime = [];         % the running time
ECD_Result = {}; % the detected community structure

for r = 1 : num_repeat
    %     global idealp weights neighbors;
    % idealp is reference point (z1, z2) where z1 and z2
    % are the maximum of the 1st and 2nd objective functions
    num_timestep = size(W_Cube, 2);  % W_Cube contains several cells restoring temporal adjacent matrices
    %% DECS only optimizes the modularity at the 1st time step
    timestep_num = 1;
    [dynMod(1,r), dynPop{1,r}, ECD_Result{1,r}, dynTime(1,r)] = ...
        ECD_1(W_Cube{timestep_num}, maxgen, pop_size, p_mutation, p_migration, p_mu_mi, Threshold);
    % calculate NMI for synthetic or real-world networks
    if flag == 1
        % for synthetic networks
        dynNmi(1,r) = NMI(GT_Matrix(:,1)',ECD_Result{1,r});
    else
        % for real-world networks
        dynNmi(1,r) = NMI(GT_Cube{timestep_num},ECD_Result{1,r});
    end
    disp(['timestep = ', num2str(timestep_num), ', Modularity = ',...
        num2str(dynMod(timestep_num,r)), ', NMI = ', num2str(dynNmi(timestep_num,r))]);
    
    %% DECS optimizes the modularity and NMI in the following time steps
    for timestep_num = 2 : num_timestep
        [dynMod(timestep_num,r), dynPop{timestep_num,r}, ECD_Result{timestep_num,r}, ...
            dynTime(timestep_num,r)] = ECD_2(W_Cube{timestep_num}, maxgen, pop_size, ...
            p_mutation, p_migration, p_mu_mi, num_neighbor, ECD_Result{timestep_num-1,r}, Threshold);
        
        if flag == 1
            dynNmi(timestep_num,r) = NMI(ECD_Result{timestep_num,r}, GT_Matrix(:,timestep_num)');
        else
            dynNmi(timestep_num,r) = NMI(ECD_Result{timestep_num,r}, GT_Cube{timestep_num});
        end
        
        disp(['timestep = ', num2str(timestep_num), ', Modularity = ',...
            num2str(dynMod(timestep_num,r)), ', NMI = ', num2str(dynNmi(timestep_num,r))]);
    end
end

avg_dynMod = sum(dynMod,2)/num_repeat;
avg_dynNmi = sum(dynNmi,2)/num_repeat;
avg_dynMod = sum(dynMod,2)/num_repeat;