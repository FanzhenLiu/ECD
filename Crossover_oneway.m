function [child_chromosome] = Crossover_oneway(chromosome, selected_pop_id, node_num)
% a pair of selected individuals to generate on children individual
child_chromosome.genome = [];
child_chromosome.clusters = [];
child_chromosome.fitness_1 = [];
child_chromosome.fitness_2 = [];
cross_over_population_id = selected_pop_id;
cross_over_count = randi(round(node_num/2),1);
cross_over_node_id = randi(node_num,cross_over_count,1);

% one-way crossover
child_chromosome.genome = chromosome(cross_over_population_id(1)).genome;
temp2_part = chromosome(cross_over_population_id(2)).genome(cross_over_node_id,:);
temp1_whole = chromosome(cross_over_population_id(1)).genome;
temp1_whole(cross_over_node_id,:) = temp2_part;
temp1_whole(:,cross_over_node_id) = temp2_part';
child_chromosome.genome = temp1_whole;
end