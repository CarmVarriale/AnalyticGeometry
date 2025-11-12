classdef testOrien < matlab.unittest.TestCase

	properties

	end

	methods (TestClassSetup)

		function addClassToPath(testCase)
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture(".."));
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture("../includes/TreeNode"));
		end

	end

	methods (Test)

		function testCreateArrayOfOriens(testCase)
			numOriens = 5;
			oriensArray = Orien.empty(numOriens,0);
			for i = 1:numOriens
				oriensArray(i) = Orien(rand(3,1)*pi/2, "321", Frame());
			end
			testCase.verifyEqual(length(oriensArray), numOriens);

			oriensArrayDefault(5) = Orien(rand(3,1)*pi/2, "321", Frame());
			testCase.verifyEqual(oriensArrayDefault(1).coords, eye(3,3))
			testCase.verifyEqual( ...
				oriensArrayDefault(1).ref.uID, ...
				"World")
			testCase.verifyEqual( ...
				oriensArrayDefault(2).ref.uID, ...
				"World")
		end

		function testFromAnglesToDirCosMat(testCase)
			testCase.verifyEqual( ...
				Orien.getDirCosMat([pi/2; 0; 0], "321"), ...
				[0 1 0; -1 0 0; 0 0 1]);
			testCase.verifyEqual( ...
				Orien.getDirCosMat([0; pi/2; 0], "321"), ...
				[0 0 -1; 0 1 0; 1 0 0]);
			testCase.verifyEqual( ...
				Orien.getDirCosMat([0; 0; pi/2], "321"), ...
				[1 0 0; 0 0 1; 0 -1 0]);
		end


		function testFromDirCosMatToAngles(testCase)
			testCase.verifyEqual( ...
				Orien.getAngleSeq([0 1 0; -1 0 0; 0 0 1], "321"), ...
				[pi/2; 0; 0]);
			testCase.verifyEqual( ...
				Orien.getAngleSeq([0 0 -1; 0 1 0; 1 0 0], "321"), ...
				[0; pi/2; 0]);
			testCase.verifyEqual( ...
				Orien.getAngleSeq([1 0 0; 0 0 1; 0 -1 0], "321"), ...
				[0; 0; pi/2]);
		end

	end

end