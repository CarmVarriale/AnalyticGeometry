function tens = outer(vec1, vec2)
% Outer product of two vectors
arguments (Input)
    vec1 (1,1) Vector
    vec2 (1,1) Vector
end
tens = Tensor(vec1.coords * vec2.resolveIn(vec1.ref).coords', vec1.ref);
end