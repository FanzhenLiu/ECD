function [chromosome] = Initial_PNM(pop_size, adjacent_array, ...
    adjacent_num, num_node, Threshold)
% generate the initial population by PNM
% top 1-Threshod edges with high conductivity are set as inter-communit edges

chromosome = struct('genome',{},'clusters',{},'fitness_1',{},'fitness_2',{});

A = adjacent_array>0;
Doc = A;
L = adjacent_array;
T = 1;
for t = 1 : T
    %disp(t);
    Array = Doc./L;
    Array(isnan(Array)) = 0;
    for i = 1 : num_node
        [P] = SolvePhysarum2(Array,i);
        Q = CaculateQ(P,Array);
        Doc = UpdateD(Q,Doc);
        PRecod{i} = Q;
    end
end
Q = (AverageP(PRecod));
[M] = RateQ(Q,Threshold);

for population_id = 1 : pop_size
    temp = -A;
    adjacent_node = randi(num_node,adjacent_num,1);
    l = length(adjacent_node);
    for i = 1:l
        tempenode = adjacent_node(i,1);
        for j = 1 : num_node
            if (A(tempenode,j)==1 && Q(tempenode,j)<M)
                temp(tempenode,j) = 1;
                temp(j,tempenode) = 1;
            end
        end
    end
    chromosome(population_id).genome = temp;
    chromosome(population_id).clusters = [];
    chromosome(population_id).fitness_1 = 0.00;
    chromosome(population_id).fitness_2 = 0.00;
end

end


function [AP]=AverageP(PRecod)
l=length(PRecod);
TP=PRecod{1};
for i=2:l
    TP=TP+PRecod{i};
end
AP=TP./l;
end
%% Caculate the fluxs Q
function [Q]=CaculateQ(AP,Array)
[x,y,z]=find(Array);
Q=Array;
l=length(x);
for i=1:l
    Q(x(i),y(i))=z(i)*abs(AP(x(i))-AP(y(i)));
end
end
%% Update the conductivity D
function [D]=UpdateD(Q,D)
u=1;
a=1;
r=0.5;
[x,y,z]=find(Q);
l=length(x);
for i=1:l
    D(x(i),y(i))=r*(z(i)^u+D(x(i),y(i)));
end
end
%%
function  [P]=SolvePhysarum2(D,outlet)
% input: D - the length matrix of a network
%        outlet
% output: P - the node pressure matrix
n=length(D);
I0=10;
Source=zeros(1,n)+I0;
Source(outlet)=-I0*(n-1);
% calculate the pressure of each node
NewMatrix = D;
S = sum(D,2);
for i = 1:n
    NewMatrix(i,i) = -S(i);
end
% consider the the pressure 0 of the outlet
NewMatrix(n+1,outlet) = 1000;
Source(n+1) = 0;
% A = rank(full(NewMatrix));
% B = rank(full([NewMatrix Source']));
% get the pressure of each node
P = NewMatrix\Source';
end

function [M] = RateQ(A,r)
[~,~,Z] = find(A);
l = length(Z);
R = round(l*r)+1;
Z=sortrows(Z,1);
M=Z(R,1);
end