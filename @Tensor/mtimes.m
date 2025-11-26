function newObj = mtimes(tens, obj)
% Multiply a tensor by a vector (tensor * vector) or by another tensor 
% (tensor * tensor).
arguments (Input)
	tens (1,1) Tensor
	obj (1,1) {mustBeA(obj, ["Vector", "Tensor"])}
end
if isa(obj, "Vector")
    newObj  = Vector( ...
		tens.resolveIn(obj.ref).coords * obj.coords, ...
		obj.ref);
else
	newObj = feval( ...
		class(tens), ...
		tens.coords * obj.resolveIn(tens.ref).coords, ...
		obj.ref);
end
end