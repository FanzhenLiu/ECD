function [chromosome] = Calculate_Q(chromosome,whole_size,num_node,num_edge,adjacent_array)
% calculate the modularity from the genome matrix and chromosome vector, respectively
% input:
%       choromosome - all chromosomes in the population
%       whole_size - the total number of the original and new individuals
%       num_node - the number of nodes in the network
%       num_edge - the number of edges in the network
%       adjacent_array - the adjacent matrix of the network
% output:
%       choromosome - all chromosomes in the population

% transform the genoem matrix into the vector whose elements
% represent the community to which a node belongs
[node_chrom] = change(chromosome,whole_size,num_node);

for pop_id = 1 : whole_size
    num_cluster = max(node_chrom(pop_id,:));
    e = zeros(1,num_cluster);
    a = zeros(1,num_cluster);
    for j = 1 : num_cluster
        cluster_id = j;
        nodes_in_cluster = find(node_chrom(pop_id,:)==cluster_id); % find the nodes within the same community
        L = length(nodes_in_cluster);  % L - the number of nodes in a community
        for k = 1 : L
            for m = 1 : num_node
                if adjacent_array(nodes_in_cluster(k),m)==1  % find the node's neighbors
                    % check if nodes are clustered into the same community
                    if chromosome(pop_id).genome(nodes_in_cluster(k),m) == 1
                        e(cluster_id) = e(cluster_id) + 1;
                    else
                        a(cluster_id) = a(cluster_id) + 1;
                    end
                end
            end
        end
    end
    e = e ./ 2;
    a = a ./ 2;
    a = a + e;
    e = e / num_edge;
    a = (a / num_edge).^2;
    Q = 0;
    for n = 1: num_cluster
        Q = Q + e(n) - a(n);
    end
    
    chromosome(pop_id).fitness_1 = Q;  % modularity calculated from the genome matrix
    chromosome(pop_id).clusters = node_chrom(pop_id,:);  % the clustering result
    chromosome(pop_id).fitness_2 = Modularity(adjacent_array, chromosome(pop_id).clusters);  % modularity
end
end
