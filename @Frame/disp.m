function disp(frame)
arguments (Input)
	frame Frame
end
if isempty(frame)
	fprintf("Empty Frame\n");
elseif isscalar(frame)
	fprintf("Frame \'%s\' with:\n", frame.name)
	fprintf("\t- Origin ")
	disp(frame.origin);
	fprintf("\t- ")
	disp(frame.orien);
	if isempty(frame.ref)
		fprintf("\t- With respect to Empty Frame \n")
	else
		fprintf("\t- With respect to \'%s\' Frame \n", frame.ref.name)
	end
elseif isvector(frame)
	arrayfun(@(fr) disp(fr), frame)
end
end