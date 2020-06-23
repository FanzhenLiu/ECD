function [child_chromosome] = Mutation(child_chromosome, mutation_rate, num_edge, edge_begin_end)
% execute mutation 
num_mutation = ceil(num_edge * mutation_rate);         % the number of mutated edges

for mutation_id = 1 : num_mutation
    mutation_edge_id = randi(num_edge,1);
    
    child_chromosome.genome(edge_begin_end(mutation_edge_id,2),edge_begin_end(mutation_edge_id,3))=...
        -1*child_chromosome.genome(edge_begin_end(mutation_edge_id,2),edge_begin_end(mutation_edge_id,3));
    child_chromosome.genome(edge_begin_end(mutation_edge_id,3),edge_begin_end(mutation_edge_id,2))=...
        -1*child_chromosome.genome(edge_begin_end(mutation_edge_id,3),edge_begin_end(mutation_edge_id,2));
end

end
