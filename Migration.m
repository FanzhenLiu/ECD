function [chromosome] = Migration(chromosome, node_num, adj_mat, p_migration)
% execute migration on a chromosome

% the nodes' communities in a vector
[clu_assignment] = change(chromosome,1,node_num);
% find the nodes in each community
clu_num = max(clu_assignment);
index = {};
for i = 1 : clu_num           % cluster_id
    index{i,1} = find(clu_assignment == i);
end

for j = 1 : clu_num
    num_node_in_clu = length(index{j,1}); % the number of nodes in community j
    
    k = 1;
    while k<=num_node_in_clu && num_node_in_clu~=0
        S = adj_mat(index{j,1},index{j,1});
        
        sum_inter = [];
        neighbor_cluster = [];
        node_id = [];
        neighbor_nodes = [];
        
        node_id  = index{j,1}(k);
        sum_intra = sum(S(k,:));  % the total nunmber of edges intra-connecting the node
        neighbor_nodes = find(adj_mat(node_id,:)==1);  % the neighbors in the network
        neighbor_cluster = unique(clu_assignment(1, neighbor_nodes));   % find the community of each neighbor
        neighbor_cluster(neighbor_cluster==j) = [];
        len = length(neighbor_cluster);
        
        if len == 0
            k = k + 1;
        else % len > 0
            sum_inter(:,1) = neighbor_cluster';  % the community id
            sum_inter(:,2) = zeros(len,1);  % the edges connecting the nodes in other communities
            
            for l = 1 : len
                % check if a node is a strongly-, neturally- or weakly-neighbor node
                neighbor_clu_id = neighbor_cluster(l);
                sum_inter(l,2) = sum(adj_mat(index{neighbor_clu_id,1},node_id));
            end
            
            max_inter = max(sum_inter(:,2));
            temp_id = find(sum_inter(:,2) == max_inter);
            % randomly select one of candidate communities
            max_inter_id = sum_inter(temp_id(randi(length(temp_id),1)),1);
            
           %% Migration on 3 kinds of nodes
            if sum_intra < max_inter  % for a weakly-neighbor node
                % inter-connected to the nodes which is originally intra-connected
                orgn_edge = find(chromosome.genome(node_id,:)==1);  % the original intra-connected  nodes
                chromosome.genome(orgn_edge,node_id) = -1;
                chromosome.genome(node_id,orgn_edge) = -1;
                % choose a candidate community to join in
                a = find(chromosome.genome(index{max_inter_id,1},node_id)==-1);
                new_edge = index{max_inter_id,1}(a);
                % randomly select nodes in the selected community to be intra-connect
                num_selected_edge = randi(length(new_edge));
                selected_edge_sort = randperm(length(new_edge),num_selected_edge);
                selected_edge = new_edge(selected_edge_sort);
                chromosome.genome(selected_edge,node_id) = 1;
                chromosome.genome(node_id,selected_edge) = 1;
                
                % update nodes' communities
                clu_assignment(1,node_id) = max_inter_id;
                % updates the nodes in each community
                index{j,1}(k) = []; % remove
                index{max_inter_id,1} = [index{max_inter_id,1} node_id]; % add
                num_node_in_clu = num_node_in_clu - 1;     
            end
            
            if sum_intra == max_inter  % for a neturally-neighbor node
                if rand(1) > p_migration % choose a candidate community to join in
                    orgn_edge = find(chromosome.genome(node_id,:)==1);   % intra-connected edges 
                    chromosome.genome(orgn_edge,node_id) = -1;
                    chromosome.genome(node_id,orgn_edge) = -1;
                    a = chromosome.genome(index{max_inter_id,1},node_id)==-1;
                    % intra-connected to nodes in the selected cadidate community
                    new_edge = index{max_inter_id,1}(a);
                    chromosome.genome(new_edge,node_id) = 1;
                    chromosome.genome(node_id,new_edge) = 1;
                    % update nodes' communities
                    clu_assignment(1,node_id) = max_inter_id;
                    % updates the nodes in each community
                    index{j,1}(k) = [];  % remove
                    index{max_inter_id,1} = [index{max_inter_id,1} node_id];  % add
                    num_node_in_clu = num_node_in_clu - 1;
                end
                
            end
            
            if sum_intra > max_inter % for a strongly-neighbor node
                k = k + 1;
            end
            
        end
        
    end
    
end
end
