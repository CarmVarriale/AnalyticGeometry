function coords = calcProject(point, dest)
% Calculate the coordinates resulting from the projection of point
% to the coorinated plane or axis of its frame
arguments (Input)
	point (1,1) Point
	dest (1,1) {mustBeMember(dest,["1","2","3","12","13","23"])}
end
arguments (Output)
	coords (3,1) double
end
switch dest
	case "1", coords = [point.coords(1); 0; 0];
	case "2", coords = [0; point.coords(2); 0];
	case "3", coords = [0; 0; point.coords(3)];
	case "12", coords = [point.coords(1:2); 0];
	case "13", coords = [point.coords(1); 0; point.coords(3)];
	case "23", coords = [0; point.coords(2:3)];
end
end