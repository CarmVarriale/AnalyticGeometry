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