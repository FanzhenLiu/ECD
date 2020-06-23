function [node_chrom] = change(chromosome,population_size,node_num)

% fprintf([repmat('%d \t',1,34) '\r\n']  ,chromosome(1).genome);

node_chrom = zeros(population_size,node_num);
for population_id = 1: population_size
%     fprintf('\r\n');
    flag = zeros(1,node_num);
    cluster_id = 1;           
    node_chrom(population_id,1) = cluster_id;
    for row_id = 1:node_num
        if flag(row_id) == 0
            flag(row_id) = 1;
%             node_chrom(population_id,row_id) = cluster_id;
            [node_chrom, flag] = row_change(chromosome(population_id).genome, node_chrom, flag, population_id, node_num, cluster_id, row_id);
            cluster_id = cluster_id + 1;
        end
     end
end
end