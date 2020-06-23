function [Mod, chromosome, Division, time] = ECD_1(adjacent_array, ...
    maxgen, pop_size, p_mutation,  p_migration, p_mu_mi, Threshold)
% detect the community structure at the 1st time step

% input:  adjacent_array - the adjacent matrix
% output: Mod - the modularity of the detected community structure
%         chromosome - chromosomes in the population
%         Division - the detected community structure
%         time - running time

if isequal(adjacent_array, adjacent_array') == 0
    adjacent_array = adjacent_array + adjacent_array';
end
% set the diagonal elements of an adjacent matrix to be 0
[row] = find(diag(adjacent_array));
for id = row
    adjacent_array(id,id) = 0;
end

[edge_begin_end] = CreatEdgeList(adjacent_array);

num_node = size(adjacent_array,2);
num_edge = sum(sum(adjacent_array))/2;  % num_edge = length(find(adjacent_array))/2;
adjacent_num =  round(0.05*num_node);  % the number of central nodes in population generation process
DynQ = zeros(maxgen,1);
children_proportion = 1;  % the proportion of the number of child inidividuals to pop_size
whole_size = ceil((1+children_proportion)*pop_size);

tic;
[chromosome] = Initial_PNM(pop_size, adjacent_array, adjacent_num, num_node, Threshold); 
[chromosome] = Calculate_Q(chromosome, pop_size, num_node, num_edge, adjacent_array);
[chromosome] = Sort_Q(chromosome, pop_size, 1);

DynQ(1,1)=chromosome(1).fitness_1;
disp(['time_stamp=1; ','0 : Q_genome=',num2str(DynQ(1,1)), '; Modularity=', ...
    num2str(chromosome(1).fitness_2)]);

for i = 1 : maxgen  % the i-th iteration
    % generate offspring
    for pop_id = (pop_size+1) : whole_size
        selected_pop_id = [];
        % select 2 different individuals from population to cossover
        while isempty(selected_pop_id) || selected_pop_id(1) == selected_pop_id(2)
            selected_pop_id = randi(pop_size, 1, 2);
        end
        % crossover
        chromosome(pop_id) = Crossover_oneway(chromosome, selected_pop_id, num_node);
        if rand(1) < p_mu_mi
            % mutation
            chromosome(pop_id) = Mutation(chromosome(pop_id), p_mutation,...
                num_edge, edge_begin_end);
        else
            % migration
            chromosome(pop_id) = Migration(chromosome(pop_id), num_node,...
                adjacent_array, p_migration);
        end
    end
    
    [chromosome] = Calculate_Q(chromosome, whole_size, num_node, num_edge, adjacent_array);
    [chromosome] = Sort_Q(chromosome, whole_size, 1);  % sort chromosomes by Q
    chromosome(101:200) = [];  % clear up chromosomes with low modularity values
    DynQ(i,1) = chromosome(1).fitness_1;
    disp(['time_stamp=1; ', num2str(i),': Q_genome=', num2str(DynQ(i,1)), ...
        '; Modularity=', num2str(chromosome(1).fitness_2)]);
end

[Division] = chromosome(1).clusters;
Mod = Modularity(adjacent_array, chromosome(1).clusters);    %¼ÆËãÄ£¿é¶È
time = toc;
end
