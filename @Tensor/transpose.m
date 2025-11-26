function newTens = transpose(tens)
% Transpose a tensor.
arguments (Input)
    tens (1,1) Tensor
end
newTens = Tensor(tens.coords', tens.ref);
end