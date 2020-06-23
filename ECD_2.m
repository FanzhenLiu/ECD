function [Mod, chromosome, Division, time] = ECD_2(adjacent_array, maxgen, pop_size, ...
    p_mutation, p_migration, p_mu_mi, num_neighbor, pre_Result, Threshold)
% detect the community structure at the time step

% input:  adjacent_array - the adjacent matrix
%         maxgen - the maximum number of iterations
%         pop_size - the population size
%         p_mutation - the mutation rate
%         p_migration - the migration rate
%         p_mu_mi - the paramater to organize the execution of mutation and migration
%         num_neighbor - the neighbor size for each subproblem in decomposition-based multi-objective optimization
%         pre_Result - the detected community structure at the last time step
%         Threshold - R=1-Threshold is the parameter related to pupulation generation
% output: Mod - the modularity of the detected community structure
%         chromosome - chromosomes in the population
%         Division - the detected community structure
%         time - running time

global idealp weights neighbors;

if isequal(adjacent_array, adjacent_array') == 0
    adjacent_array = adjacent_array + adjacent_array';
end
% set the diagonal elements of an adjacent matrix to be 0
[row] = find(diag(adjacent_array));
for id = row
    adjacent_array(id,id) = 0;
end

[edge_begin_end] = CreatEdgeList(adjacent_array);
num_node = size(adjacent_array,2);  % the number of nodes
num_edge = sum(sum(adjacent_array))/2;  % the number of edges
adjacent_num = round(0.05*num_node);  % the number of central nodes in population generation process
child_chromosome = struct('genome',{},'clusters',{},'fitness_1',{},'fitness_2',{});

%% Initialization based on Tchebycheff approach
tic;
EP = [];  % non-dominated solution set
idealp = -Inf * ones(1,2);  % the reference point (z1,z2)
% find neighbor solutions to each subproblems
[weights, neighbors] = init_weight(pop_size,num_neighbor);
[chromosome] = Initial_PNM(pop_size, adjacent_array, adjacent_num, num_node, Threshold);
% calculate the values of modularity and NMI
[chromosome] = evaluate_objectives(chromosome, pop_size, num_node,...
    num_edge, adjacent_array, pre_Result);
% find the reference point after initialization
f = [];
for j = 1 : pop_size
    f = [f; chromosome(j).fitness_1];
    idealp = min(f);
end

%% Compute snapshot and temporal costs
% the iteration process
for t = 1 : maxgen  % the t-th iteration
    % implement operations on individuals selected from neighbors
    for pop_id = 1 : pop_size
        selected_neighbor_id = [];
        selected_pop_id = [];
        % select two different individuals from neighbors
        while isempty(selected_neighbor_id) || selected_neighbor_id(1) == selected_neighbor_id(2)
            selected_neighbor_id = randi(num_neighbor, 1, 2);
        end
        selected_pop_id = neighbors(pop_id, selected_neighbor_id);
        % execute operators to reproduce the offspring
        % crossover
        child_chromosome(pop_id) = Crossover_oneway(chromosome, selected_pop_id, num_node);
        if rand(1) < p_mu_mi
            % mutate
            child_chromosome(pop_id) = Mutation(child_chromosome(pop_id), ...
                p_mutation, num_edge, edge_begin_end);
        else
            % migrate
            child_chromosome(pop_id) = Migration(child_chromosome(pop_id), ...
                num_node, adjacent_array, p_migration);
        end
        % calculate the fitness values of clustering results
        child_chromosome(pop_id) = evaluate_objectives(child_chromosome(pop_id), 1, ...
            num_node, num_edge, adjacent_array, pre_Result);
        
        % update the population
        for k = neighbors(pop_id,:)
            child_fit = decomposedFitness(weights(k,:), child_chromosome(pop_id).fitness_1, idealp);
            gbest_fit = decomposedFitness(weights(k,:), chromosome(k).fitness_1, idealp);
            if child_fit < gbest_fit
                chromosome(k).genome = child_chromosome(pop_id).genome;
                chromosome(k).clusters = child_chromosome(pop_id).clusters;
                chromosome(k).fitness_1 = child_chromosome(pop_id).fitness_1;
                chromosome(k).fitness_2 = child_chromosome(pop_id).fitness_2;
            end
        end
        
    end
    
    %% Find non-dominated solutions
    for pop_id = 1 : pop_size
        % non-dominated sorting -- coded Q and NMI
        if isempty(EP)
            EP = [EP chromosome(pop_id)];
        else
            isDominate = 0;
            isExist = 0;
            rmindex = [];
            for k = 1 : numel(EP) % numel returns the number of elements
                if isequal(chromosome(pop_id).clusters, EP(k).clusters)  % isequal(chromosome(pop_id).genome, EP(k).genome)
                    isExist = 1;
                end
                if dominate(chromosome(pop_id), EP(k))
                    rmindex = [rmindex k];
                elseif dominate(EP(k), chromosome(pop_id))
                    isDominate = 1;
                end
            end
            EP(rmindex) = [];
            if ~isDominate && ~isExist
                EP = [EP chromosome(pop_id)];
            end
        end
        
        % update the reference point
        idealp = min([child_chromosome(pop_id).fitness_1; idealp]);
    end
    
end

Modularity = [];
for front = EP
    Modularity = [Modularity; abs(front.fitness_2(1))];
end
[~,index] = max(Modularity);
Division = EP(index).clusters;  % restore the optimal solution, i.e., the network division with high quality
% dynPop{timestep_num,r} = chromosome;
Mod = -EP(index).fitness_2(1); % decoded positive "+" modularity
time = toc;

end