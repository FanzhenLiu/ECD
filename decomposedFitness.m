function tc_fit = decomposedFitness(weight,objectives,idealpoint )
weight((weight == 0)) = 0.00001;  % wight>0
part2 = abs(objectives - idealpoint);
tc_fit = max(weight.*part2,[],2);   
end