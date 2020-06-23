function b = dominate(x,y)
    if isfield(x,'fitness_1')
        x = x.fitness_1;
    end
    if isfield(y,'fitness_1')
        y = y.fitness_1;
    end   
    b=all(x<=y) && any(x<y);
end