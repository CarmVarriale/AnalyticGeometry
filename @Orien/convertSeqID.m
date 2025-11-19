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
if ~newSeqID == orien.seqID
	angles = Orien.getAngleSeq(orien.dirCosMat, newSeqID);
	orien = Orien(angles, newSeqID, orien.ref);
end
end