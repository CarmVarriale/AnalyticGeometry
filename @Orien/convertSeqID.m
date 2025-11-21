function orien = convertSeqID(orien, newSeqID)
% Express the same orientation as if resulting from a different sequence of
% angles
arguments (Input)
    orien (1,1) Orien
    newSeqID string
end
arguments (Output)
    orien (1,1) Orien
end
if newSeqID ~= orien.seqID
    orien.angles = orien.quat.euler( ...
        newSeqID ...
            .replace("3","Z").replace("2","Y").replace("1","X"), ...
        "frame")';
    orien.seqID = newSeqID;
end
end