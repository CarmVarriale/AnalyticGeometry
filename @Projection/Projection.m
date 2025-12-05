classdef Projection < Tensor
% Projection tensor for projecting vectors onto geometric entities
    % A projection tensor can be used to project vectors onto lines, planes,
    % or coordinate axes/planes of a reference frame.

    methods
       
        %% Constructor
        function proj = Projection(vec, type)
            arguments (Input)
                vec (1,1) Vector
                type (1,1) string {mustBeMember(type, ["para", "perp"])}
            end
            coords = outer(vec.unit, vec.unit).coords;
            if type == "perp"
                coords = eye(3) - coords;
            end
            proj@Tensor(coords, vec.ref);
        end

    end

end