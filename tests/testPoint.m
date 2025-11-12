classdef testPoint < matlab.unittest.TestCase

	properties

		world, fr1, fr2, fr2a, fr2b, fr2c, fr3a, fr3b, fr3c

	end

	methods (TestClassSetup)

		function addClassToPath(testCase)
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture(".."));
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture("../includes/TreeNode"));
		end

	end

	methods (TestMethodSetup)

		function createTreeFrame(testCase)
			% Create tree of Frames with World at its root
			% The tree has the folllowing structure:
			%
			% World
			% ├── Frame1
			%     ├── Frame2a
			%     │   └── Frame3a
			%     ├── Frame2b
			%     │   └── Frame3b
			%     └── Frame2c
			%         └── Frame3c

			testCase.world = World.getWorld();

			testCase.fr1 = Frame("Frame1", ...
				Point([1; 1; 1], testCase.world), ...
				Orien([0; 0; 0], "321", testCase.world), ...
				testCase.world);

			testCase.fr2a = Frame("Frame2a", ...
				Point([2; 0; 0], testCase.fr1), ...
				Orien([0; 0; 0], "321", testCase.fr1), ...
				testCase.fr1);
			testCase.fr2b = Frame("Frame2b", ...
				Point([0; 2; 0], testCase.fr1), ...
				Orien([0; 0; 0], "321", testCase.fr1), ...
				testCase.fr1);
			testCase.fr2c = Frame("Frame2c", ...
				Point([0; 0; 2], testCase.fr1), ...
				Orien([0; 0; 0], "321", testCase.fr1), ...
				testCase.fr1);

			testCase.fr3a = Frame("Frame3a", ...
				Point([0; 0; 0], testCase.fr2a), ...
				Orien([0; 0; pi/2], "321", testCase.fr2a), ...
				testCase.fr2a);
			testCase.fr3b = Frame("Frame3b", ...
				Point([0; 0; 0], testCase.fr2b), ...
				Orien([0; pi/2; 0], "321", testCase.fr2b), ...
				testCase.fr2b);
			testCase.fr3c = Frame("Frame3c", ...
				Point([0; 0; 0], testCase.fr2c), ...
				Orien([pi/2; 0; 0], "321", testCase.fr2c), ...
				testCase.fr2c);

			testCase.addTeardown(@clear, "World", "getWorld")
		end

	end

	%%
	methods (Test)

		function testCreatePointInEmptyFrame(testCase)
			try
				Point(rand(3,1), Frame.empty());
			catch ME
				testCase.verifyMatches( ...
					ME.identifier, ...
					"MATLAB:validation:IncompatibleSize");
			end
		end


		function testCreateArrayOfPoints(testCase)
			numPoints = 5;
			pointsArray = Point.empty(numPoints,0);
			for i = 1:numPoints
				pointsArray(i) = Point(rand(3,1), testCase.world);
			end
			testCase.verifyEqual(length(pointsArray), numPoints);

			pointsArrayDefault(5) = Point(rand(3,1), testCase.world);
			testCase.verifyEqual(pointsArrayDefault(1).coords, [0; 0; 0])
			testCase.verifyEqual( ...
				pointsArrayDefault(1).ref.uID, ...
				"World")
			testCase.verifyEqual( ...
				pointsArrayDefault(2).ref.uID, ...
				"World")
		end


		function testGetPointCoords(testCase)
			coords = rand(3,1);
			p = Point(coords, testCase.world);
			expCoords = coords;

			testCase.verifyEqual(p.coords, expCoords);
			testCase.verifyEqual(p.coords(1), expCoords(1));
			testCase.verifyEqual(p.coords(2), expCoords(2));
			testCase.verifyEqual(p.coords(3), expCoords(3));
		end


		function testSetPointCoords(testCase)
			p = Point(rand(3,1), testCase.world);
			expCoords1 = [1; 2; 3];
			expCoords2 = [4; 5; 6];

			p.coords(1) = 1;
			p.coords(2) = 2;
			p.coords(3) = 3;
			testCase.verifyEqual(p.coords, expCoords1)

			p.coords = [4; 5; 6];
			testCase.verifyEqual(p.coords, expCoords2)
		end


		function testGetPointRadialVector(testCase)
			coords = rand(3,1);
			p = Point(coords, testCase.world);
			expCoords = coords;

			testCase.verifyEqual(p.radius.coords, expCoords);
			testCase.verifyEqual(p.radius.magnitude, norm(expCoords));
			testCase.verifyEqual(p.radius.ref, testCase.world);
		end


		function testViewIn(testCase)
			coords = [10;10;10];

			p1 = Point(coords, testCase.fr1);
			testCase.verifyEqual(p1.resolveIn(testCase.fr1).coords, [10;10;10]);
			testCase.verifyEqual(p1.resolveIn(testCase.world).coords, [11;11;11]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr2a).coords, [8;10;10]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr2b).coords, [10;8;10]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr2c).coords, [10;10;8]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr3a).coords, [8;10;-10]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr3b).coords, [-10;8;10]);
			testCase.verifyEqual(p1.resolveIn(testCase.fr3c).coords, [10;-10;8]);

			p3c = Point(coords, testCase.fr3c);
			testCase.verifyEqual(p3c.resolveIn(testCase.fr2c).coords, [-10;10;10]);
			testCase.verifyEqual(p3c.resolveIn(testCase.world).coords, [-9;11;13]);
			testCase.verifyEqual(p3c.resolveIn(testCase.fr3a).coords, [-12;12;-10]);
		end


		function testTranslatePoint(testCase)
			p1 = Point([1 0 0], testCase.world);
			v1 = Vector([1 0 0], testCase.world);
			v2 = Vector([0 1 0], testCase.world);
			v3 = Vector([0 0 1], testCase.world);
			v4 = Vector([-2 -1 -1], testCase.world);
			testCase.verifyEqual(p1.translate(v1).coords, [2; 0; 0]);
			testCase.verifyEqual(p1.translate(v2).coords, [1; 1; 0]);
			testCase.verifyEqual( ...
				p1.translate(v3).translate(v4).coords, ...
				[-1; -1; 0]);
			testCase.verifyError( ...
				@() p1.translate(Vector([0 0 0], testCase.fr1)), ...
				"Point:translate:sameRef");
		end


		function testRotatePoint(testCase)
			p0 = Point([0 0 0], testCase.world);
			p1 = Point([1 0 0], testCase.world);

			r1 = Orien([pi/2, 0, 0], "321", testCase.world);
			r2 = Orien([0, -3*pi/2, 0], "321", testCase.world);
			r3 = Orien([0, 0, -pi/2], "321", testCase.world);
			r4 = Orien([pi/4, 0, 0], "321", testCase.world);

			testCase.verifyEqual( ...
				p1.rotate(r1,p0).coords, ...
				[0; 1; 0]);
			testCase.verifyEqual( ...
				p1.rotate(r2,p0).coords, ...
				[0; 0; -1]);
			testCase.verifyEqual( ...
				p1.rotate(r1,p0).rotate(r2,p0).rotate(r1,p0).coords, ...
				[-1; 0; 0]);
			testCase.verifyEqual( ...
				p1.rotate(r3,p0).coords, ...
				[1; 0; 0]);
			testCase.verifyEqual( ...
				p1.rotate(r4,p0).coords, ...
				[sqrt(2); sqrt(2); 0]/2, ...
				AbsTol=1e-12);
			testCase.verifyEqual( ...
				p1.rotate(r4,p0).rotate(r4,p0).coords, ...
				[0; 1; 0], ...
				AbsTol=1e-12);
			testCase.verifyError( ...
				@() p1.rotate(r1, Point([0; 0; 0], testCase.fr1)), ...
				"Point:rotate:sameRef");
		end

	end

end