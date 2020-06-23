function [edge_begin_end] = CreatEdgeList(adjacent_array)
[x,y,~] = find (adjacent_array);
l = length(x); %±ßµÄÊıÁ¿*2
edge_begin_end = zeros(l/2,3);
j = 0;
for i = 1 : l
    if x(i) > y(i)
        j = j + 1;
        edge_begin_end(j,1) = j;
        edge_begin_end(j,2) = x(i);
        edge_begin_end(j,3) = y(i);
    end
end
end