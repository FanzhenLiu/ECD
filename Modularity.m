function [ y ] = Modularity( adj_mat, clu_assignment )
%% n: the number of clusters
n = max(clu_assignment);

%% L: the total number of edges in the network
L = sum(sum(adj_mat))/2;

%% 
Q = 0;
for i = 1:n
    index = find(clu_assignment == i);
    S = adj_mat(index,index);
    li = sum(sum(S))/2;
    di = 0;
    for j = 1:length(index)
        di = di + sum(adj_mat(index(j),:));
    end
    Q = Q + (li - ((di)^2)/(4*L));
end
y = Q/L;
end