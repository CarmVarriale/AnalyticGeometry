function newVec = uminus(vec)
% Returns the opposite vector in the same Frame
arguments (Input)
    vec (1,1) Vector
end
arguments (Output)
    newVec (1,1) Vector
end
newVec = Vector(-vec.coords, vec.ref);
end