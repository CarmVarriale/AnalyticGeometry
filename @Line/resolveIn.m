function line = resolveIn(line, frame)
% Express the line in a different reference frame
arguments (Input)
	line (1,1) Line
	frame (1,1) Frame
end
line.anchor = line.anchor.resolveIn(frame);
line.direc = line.direc.resolveIn(frame);
end
