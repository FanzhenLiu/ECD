function [node_chrom,flag] = row_change(genome,node_chrom,flag, ... 
    population_id,node_num,cluster_id,row_id)
node_chrom(population_id,row_id) =cluster_id;
for colum_id = 1 : node_num  

    if genome(row_id,colum_id)==1 && flag(colum_id)==0
        flag(colum_id) = 1;
        [node_chrom,flag] = row_change(genome,node_chrom,flag,population_id,node_num,cluster_id,colum_id);
    end
end