function disp(tens)
arguments
	tens Tensor
end
if isempty(tens)
	fprintf("Empty Tensor\n");
elseif isvector(tens)
	for i = 1:numel(tens)
		if isempty(tens(i).ref)
			fprintf("Tensor with the following coords " + ...
				"in empty Frame:\n"); 
			disp(tens(i).coords);
		else
			fprintf( ...
				"Tensor with the following coords " + ...
				"in \'%s\' Frame:\n", ...
				tens(i).ref.name);
			disp(tens(i).coords)
		end
	end
end
end
