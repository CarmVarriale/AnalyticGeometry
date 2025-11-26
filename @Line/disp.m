function disp(line)
% Display a Line object
fprintf("Line with:\n");
fprintf("\t- Anchor ")
disp(line.anchor);
fprintf("\t- Direction ")
disp(line.direc);
end
