function [chromosome] = Sort_Q(chromosome,whole_size,signal)
% sort the chromosomes by modularity:
% signal = 1£¬sort chromosomes by the modularity value calculated from the adjacent matrix;
% signal = 2£¬sort chromosomes by the modularity values calculated from the chromosome vector

if signal == 1
    for i = 1:whole_size
        k = i;
        for j = i + 1:whole_size
            if chromosome(j).fitness_1(1) > chromosome(k).fitness_1(1)
                k = j;
            end
        end
        if k ~= i
            temp = chromosome(i);
            chromosome(i) = chromosome(k);
            chromosome(k) = temp;
        end
    end
end

if signal == 2
    for i = 1:whole_size
        k = i;
        for j = i + 1:whole_size
            if chromosome(j).fitness_2 > chromosome(k).fitness_2
                k = j;
            end
            % compare the modularity values calculated from the adjacent matrix 
            % when the modularity values calculated from the chromosome vector are the same 
            if chromosome(j).fitness_2(1) == chromosome(k).fitness_2(1) && chromosome(j).fitness_1(1) > chromosome(k).fitness_1(1)
                k = j;
            end 
        end
        if k ~= i
            temp = chromosome(i);
            chromosome(i) = chromosome(k);
            chromosome(k) = temp;
        end
    end
end

end
