function flag = isequal(A, B)
% Compare two GeomElem objects for equality
arguments (Input)
    A GeomElem
    B GeomElem   
end
flag = eq(A, B);
end