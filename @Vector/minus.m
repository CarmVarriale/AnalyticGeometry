function newVec = minus(vec1, vec2)
arguments (Input)
    vec1 (1,1) Vector
    vec2 (1,1) Vector
end
arguments (Output)
    newVec (1,1) Vector
end
newVec = vec1 + uminus(vec2);
end