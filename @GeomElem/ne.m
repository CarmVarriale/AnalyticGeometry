function flag = ne(A, B)
% Compare two GeomElem objects for inequality
%
% Two GeomElem objects are considered not equal if they have different
% coordinates when resolved in the same Frame.
flag = ~eq(A, B);
end
