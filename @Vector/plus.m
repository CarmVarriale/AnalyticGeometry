function newVec = plus(vec1, vec2)
arguments (Input)
    vec1 (1,1) Vector
    vec2 (1,1) Vector
end
arguments (Output)
    newVec (1,1) Vector
end
if vec1.ref == vec2.ref
    newVec = Vector(vec1.coords + vec2.coords, vec1.ref);
else
    newVec = vec1 + vec2.resolveIn(vec1.ref);
end
end