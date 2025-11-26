classdef testPoint < matlab.unittest.TestCase

	properties

		frames

	end

	methods (TestClassSetup)

		function addClassToPath(testCase)
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture(".."));
			testCase.applyFixture( ...
				matlab.unittest.fixtures.PathFixture("../includes/TreeNode"));
		end

		function setupFrames(testCase)
			testCase.frames = testCase.applyFixture(...
				FrameHierarchyFixture());
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
				pointsArray(i) = Point(rand(3,1), testCase.frames.world);
			end
			testCase.verifyEqual(length(pointsArray), numPoints);

			pointsArrayDefault(5) = Point(rand(3,1), testCase.frames.world);
			testCase.verifyEqual(pointsArrayDefault(1).coords, [0; 0; 0])
			testCase.verifyEqual( ...
				pointsArrayDefault(1).ref.name, ...
				"World")
			testCase.verifyEqual( ...
				pointsArrayDefault(2).ref.name, ...
				"World")
		end


		function testGetPointCoords(testCase)
			coords = rand(3,1);
			p = Point(coords, testCase.frames.world);
			expCoords = coords;

			testCase.verifyEqual(p.coords, expCoords);
			testCase.verifyEqual(p.coords(1), expCoords(1));
			testCase.verifyEqual(p.coords(2), expCoords(2));
			testCase.verifyEqual(p.coords(3), expCoords(3));
		end


		function testSetPointCoords(testCase)
			p = Point(rand(3,1), testCase.frames.world);
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
			p = Point(coords, testCase.frames.world);
			expCoords = coords;

			testCase.verifyEqual(p.radius.coords, expCoords);
			testCase.verifyEqual(p.radius.magnitude, norm(expCoords));
			testCase.verifyEqual(p.radius.ref, testCase.frames.world);
		end


		function testTranslatePoint(testCase)
			p1 = Point([1 0 0], testCase.frames.world);
			v1 = Vector([1 0 0], testCase.frames.world);
			v2 = Vector([0 1 0], testCase.frames.world);
			v3 = Vector([0 0 1], testCase.frames.world);
			v4 = Vector([-2 -1 -1], testCase.frames.world);

			% Test translation with vectors in the same frame
			testCase.verifyEqual(p1.translate(v1).coords, [2; 0; 0]);
			testCase.verifyEqual(p1.translate(v2).coords, [1; 1; 0]);
			testCase.verifyEqual( ...
				p1.translate(v3).translate(v4).coords, ...
				[-1; -1; 0]);
			
			% Test translation with vectors in different frames
			p2 = Point([1 0 0], testCase.frames.fr1);
			v5 = Vector([1 0 0], testCase.frames.fr2a);
			v6 = Vector([0 1 0], testCase.frames.fr3a);
			testCase.verifyEqual(p2.translate(v5).coords, ...
				[2; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(p2.translate(v6).coords, ...
				[1; 0; 1], ...
				AbsTol = 1e-15);
			
			% Test that mixed frame translation resolves correctly
			p3 = Point([2 0 0], testCase.frames.fr1);
			v7 = Vector([1 0 0], testCase.frames.world);
			testCase.verifyEqual(p3.translate(v7).ref, p3.ref);
			testCase.verifySameHandle(p3.translate(v7).ref, p3.ref);
		end


		function testRotatePoint(testCase)
			p0 = Point([0 0 0], testCase.frames.world);
			p1 = Point([1 0 0], testCase.frames.world);

			r1 = Orien([pi/2, 0, 0], "321", testCase.frames.world);
			r2 = Orien([0, -3*pi/2, 0], "321", testCase.frames.world);
			r3 = Orien([0, 0, -pi/2], "321", testCase.frames.world);
			r4 = Orien([pi/4, 0, 0], "321", testCase.frames.world);

			% Test rotation about a point with orientation
			testCase.verifyEqual( ...
				p1.rotate(p0, r1).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				p1.rotate(p0, r2).coords, ...
				[0; 0; -1], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				p1.rotate(p0, r1).rotate(p0, r2).rotate(p0, r1).coords, ...
				[-1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				p1.rotate(p0, r3).coords, ...
				[1; 0; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				p1.rotate(p0, r4).coords, ...
				[sqrt(2); sqrt(2); 0]/2, ...
				AbsTol=1e-15);
			testCase.verifyEqual( ...
				p1.rotate(p0, r4).rotate(p0, r4).coords, ...
				[0; 1; 0], ...
				AbsTol=1e-15);
			
			% Test rotation with orientation in different frame
			p2 = Point([1 0 0], testCase.frames.fr1);
			r5 = Orien([pi/2, 0, 0], "321", testCase.frames.world);
			center1 = Point([0 0 0], testCase.frames.fr1);
			testCase.verifyEqual( ...
				p2.rotate(center1, r5).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			
			p3 = Point([3 0 0], testCase.frames.fr1);
			r6 = Orien([0, 0, pi/2], "321", testCase.frames.fr2a);
			center2 = Point([1 1 1], testCase.frames.fr1);
			testCase.verifyEqual( ...
				p3.rotate(center2, r6).coords, ...
				[3; 2; 0], ...
				AbsTol = 1e-15);
			testCase.verifyEqual( ...
				p3.rotate(center2, r6).ref, ...
				testCase.frames.fr1);
			
			p4 = Point([2 0 0], testCase.frames.fr1);
			r7 = Orien([pi/2, 0, 0], "321", testCase.frames.fr3a);
			center3 = Point([1 1 1], testCase.frames.world);
			testCase.verifyEqual( ...
				p4.rotate(center3, r7), ...
				Point([0; 0; 2], testCase.frames.fr1), ...
				AbsTol = 1e-15);
			
			% Test rotation about an axis
			p5 = Point([1 0 0], testCase.frames.world);
			axis1 = Line(p0, Vector([0 0 1], testCase.frames.world));  
			testCase.verifyEqual( ...
				p5.rotate(axis1, pi/2).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			
			% Test 180 degree rotation about Y-axis
			p6 = Point([1 0 0], testCase.frames.world);
			axis2 = Line(p0, Vector([0 1 0], testCase.frames.world));
			testCase.verifyEqual( ...
				p6.rotate(axis2, pi).coords, ...
				[-1; 0; 0], ...
				AbsTol = 1e-15);
			
			% Test rotation about arbitrary axis
			p7 = Point([1 0 0], testCase.frames.world);
			axis3 = Line(p0, Vector([1 1 0], testCase.frames.world));  
			result = p7.rotate(axis3, pi);
			testCase.verifyEqual( ...
				result.coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
			
			% Test rotation about axis with different center point
			p8 = Point([2 1 0], testCase.frames.world);
			center4 = Point([1 1 0], testCase.frames.world);
			axis4 = Line(center4, Vector([0 0 1], testCase.frames.world));
			testCase.verifyEqual( ...
				p8.rotate(axis4, pi/2).coords, ...
				[1; 2; 0], ...
				AbsTol = 1e-15);
			
			% Test rotation with axis in different frame
			p9 = Point([1 0 0], testCase.frames.fr1);
			center5 = Point([0 0 0], testCase.frames.fr1);
			axis5 = Line(center5, Vector([0 0 1], testCase.frames.world));
			testCase.verifyEqual( ...
				p9.rotate(axis5, pi/2).coords, ...
				[0; 1; 0], ...
				AbsTol = 1e-15);
		end


		function testResolveInParent(testCase)
			% Test resolving point from child to parent frame
			p1 = Point([2; 3; 4], testCase.frames.fr1);
			p1Parent = p1.resolveInParent();
			testCase.verifyEqual(p1Parent.coords, [3; 4; 5]);
			testCase.verifyEqual(p1Parent.ref, testCase.frames.world);
			
			% Test resolving from grandchild to parent
			p3a = Point([1; 1; 1], testCase.frames.fr3a);
			p3aParent = p3a.resolveInParent();
			testCase.verifyEqual(p3aParent.ref, testCase.frames.fr2a);
			testCase.verifyEqual( ...
				p3aParent.coords, ...
				[1; -1; 1], ...
				AbsTol = 1e-15);
			
			% Verify original point unchanged
			testCase.verifyEqual(p1.coords, [2; 3; 4]);
			testCase.verifyEqual(p1.ref, testCase.frames.fr1);
		end


		function testResolveInChild(testCase)
			% Test resolving point from parent to child frame
			p1 = Point([3; 4; 5], testCase.frames.world);
			p1Child = p1.resolveInChild(testCase.frames.fr1);
			testCase.verifyEqual(p1Child.coords, [2; 3; 4]);
			testCase.verifyEqual(p1Child.ref, testCase.frames.fr1);
			
			% Test resolving from grandparent to grandchild
			pWorld = Point([4; 1; 2], testCase.frames.world);
			p3a = pWorld.resolveInChild(testCase.frames.fr3a);
			testCase.verifyEqual(p3a.ref, testCase.frames.fr3a);
			testCase.verifyEqual( ...
				p3a.coords, ...
				[4; 2; -1], ...
				AbsTol = 1e-15);
			
			% Verify original point unchanged
			testCase.verifyEqual(pWorld.coords, [4; 1; 2]);
			testCase.verifyEqual(pWorld.ref, testCase.frames.world);
		end


		function testResolveIn(testCase)
			% Test resolveIn with parent frame
			p2a = Point([5; 5; 5], testCase.frames.fr2a);
			p2aInParent = p2a.resolveIn(testCase.frames.fr1);
			testCase.verifyEqual(p2aInParent.coords, [7; 5; 5]);
			testCase.verifyEqual(p2aInParent.ref, testCase.frames.fr1);
			
			% Test resolveIn with child frame
			p1 = Point([7; 5; 5], testCase.frames.fr1);
			p1InChild = p1.resolveIn(testCase.frames.fr2a);
			testCase.verifyEqual(p1InChild.coords, [5; 5; 5]);
			testCase.verifyEqual(p1InChild.ref, testCase.frames.fr2a);
			
			% Test resolveIn with ancestor (grandparent)
			p3a = Point([2; 2; 2], testCase.frames.fr3a);
			p3aInWorld = p3a.resolveIn(testCase.frames.world);
			testCase.verifyEqual( ...
				p3aInWorld.coords, ...
				[5; -1; 3], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(p3aInWorld.ref, testCase.frames.world);
			
			% Test resolveIn with descendant (grandchild)
			pWorld = Point([5; -1; 3], testCase.frames.world);
			pIn3a = pWorld.resolveIn(testCase.frames.fr3a);
			testCase.verifyEqual( ...
				pIn3a.coords, ...
				[2; 2; 2], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(pIn3a.ref, testCase.frames.fr3a);
			
			% Test resolveIn with sibling (different branch)
			p2a = Point([1; 0; 0], testCase.frames.fr2a);
			p2aIn2b = p2a.resolveIn(testCase.frames.fr2b);
			testCase.verifyEqual(p2aIn2b.coords, [3; -2; 0]);
			testCase.verifyEqual(p2aIn2b.ref, testCase.frames.fr2b);
		end


		function testResolveInWorld(testCase)
			% Test resolveInWorld from various frames
			p1 = Point([5; 5; 5], testCase.frames.fr1);
			p1World = p1.resolveInWorld();
			testCase.verifyEqual(p1World.coords, [6; 6; 6]);
			testCase.verifyEqual(p1World.ref, testCase.frames.world);
			
			p3c = Point([3; 3; 3], testCase.frames.fr3c);
			p3cWorld = p3c.resolveInWorld();
			testCase.verifyEqual( ...
				p3cWorld.coords, ...
				[-2; 4; 6], ...
				AbsTol = 1e-15);
			testCase.verifyEqual(p3cWorld.ref, testCase.frames.world);
		end


		function testPlusOperator(testCase)
			% Test adding vector to point in same frame
			p1 = Point([1; 2; 3], testCase.frames.world);
			v1 = Vector([4; 5; 6], testCase.frames.world);
			p2 = p1 + v1;
			testCase.verifyEqual(p2.coords, [5; 7; 9]);
			testCase.verifyEqual(p2.ref, testCase.frames.world);
			
			% Test adding vector in different frame
			p3 = Point([1; 0; 0], testCase.frames.fr1);
			v2 = Vector([1; 0; 0], testCase.frames.fr2a);
			p4 = p3 + v2;
			testCase.verifyEqual(p4.coords, [2; 0; 0]);
			testCase.verifyEqual(p4.ref, testCase.frames.fr1);
			
			% Verify original unchanged
			testCase.verifyEqual(p1.coords, [1; 2; 3]);
		end


		function testMinusOperator(testCase)
			% Test subtracting points in same frame
			p1 = Point([5; 7; 9], testCase.frames.world);
			p2 = Point([1; 2; 3], testCase.frames.world);
			v = p1 - p2;
			testCase.verifyClass(v, "Vector");
			testCase.verifyEqual(v.coords, [4; 5; 6]);
			testCase.verifyEqual(v.ref, testCase.frames.world);
			
			% Test subtracting points in different frames
			p3 = Point([3; 1; 1], testCase.frames.world);
			p4 = Point([0; 0; 0], testCase.frames.fr1);
			v2 = p3 - p4;
			testCase.verifyEqual(v2.coords, [2; 0; 0]);
			testCase.verifyEqual(v2.ref, testCase.frames.world);
		end


		function testUminusOperator(testCase)
			% Test unary minus operator
			p1 = Point([3; 4; 5], testCase.frames.world);
			p2 = -p1;
			testCase.verifyEqual(p2.coords, [-3; -4; -5]);
			testCase.verifyEqual(p2.ref, testCase.frames.world);
			
			% Verify original unchanged
			testCase.verifyEqual(p1.coords, [3; 4; 5]);
			
			% Test with point in different frame
			p3 = Point([2; -3; 1], testCase.frames.fr1);
			p4 = -p3;
			testCase.verifyEqual(p4.coords, [-2; 3; -1]);
			testCase.verifyEqual(p4.ref, testCase.frames.fr1);
		end


		function testProjectPoint(testCase)
			p = Point([3; 4; 5], testCase.frames.world);
			
			% Project to axis 1 (X)
			p1 = p.project("1");
			testCase.verifyEqual(p1.coords, [3; 0; 0]);
			testCase.verifyEqual(p1.ref, testCase.frames.world);
			
			% Project to axis 2 (Y)
			p2 = p.project("2");
			testCase.verifyEqual(p2.coords, [0; 4; 0]);
			
			% Project to axis 3 (Z)
			p3 = p.project("3");
			testCase.verifyEqual(p3.coords, [0; 0; 5]);
			
			% Project to plane 12 (XY)
			p12 = p.project("12");
			testCase.verifyEqual(p12.coords, [3; 4; 0]);
			
			% Project to plane 13 (XZ)
			p13 = p.project("13");
			testCase.verifyEqual(p13.coords, [3; 0; 5]);
			
		% Project to plane 23 (YZ)
		p23 = p.project("23");
		testCase.verifyEqual(p23.coords, [0; 4; 5]);
		
		% Verify original unchanged
		testCase.verifyEqual(p.coords, [3; 4; 5]);
	end


	function testProjectPointOntoLine(testCase)
		% Test projecting a point onto a line through origin
		p = Point([3; 4; 5], testCase.frames.world);
		
		% Line along X-axis
		lineX = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Point([1; 0; 0], testCase.frames.world));
		
		pX = p.project(lineX);
		testCase.verifyEqual(pX.coords, [3; 0; 0], "AbsTol", 1e-15);
		testCase.verifyEqual(pX.ref, testCase.frames.world);
		
		% Line along Y-axis
		lineY = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Point([0; 1; 0], testCase.frames.world));
		
		pY = p.project(lineY);
		testCase.verifyEqual(pY.coords, [0; 4; 0], "AbsTol", 1e-15);
		
		% Line along Z-axis
		lineZ = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Point([0; 0; 1], testCase.frames.world));
		
		pZ = p.project(lineZ);
		testCase.verifyEqual(pZ.coords, [0; 0; 5], "AbsTol", 1e-15);
		
		% Verify original unchanged
		testCase.verifyEqual(p.coords, [3; 4; 5]);
	end


	function testProjectPointOntoOffsetLine(testCase)
		% Test projecting onto a line not passing through origin
		p = Point([5; 3; 2], testCase.frames.world);
		
		% Line parallel to X-axis but offset
		line = Line( ...
			Point([0; 2; 2], testCase.frames.world), ...
			Point([1; 2; 2], testCase.frames.world));
		
		pProj = p.project(line);
		testCase.verifyEqual(pProj.coords, [5; 2; 2], "AbsTol", 1e-15);
		testCase.verifyEqual(pProj.ref, testCase.frames.world);
	end


	function testProjectPointOntoDiagonalLine(testCase)
		% Test projecting onto a diagonal line
		p = Point([3; 3; 0], testCase.frames.world);
		
		% Line along diagonal in XY plane
		line = Line( ...
			Point([0; 0; 0], testCase.frames.world), ...
			Point([1; 1; 0], testCase.frames.world));
		
		pProj = p.project(line);
		% Projection of [3,3,0] onto [1,1,0] is [3,3,0]
		testCase.verifyEqual(pProj.coords, [3; 3; 0], "AbsTol", 1e-15);
		
		% Test with point off the line
		p2 = Point([4; 2; 1], testCase.frames.world);
		p2Proj = p2.project(line);
		% (4,2,1)·(1,1,0)/||(1,1,0)|| = 6/√2, proj = 6/√2 * (1,1,0)/√2 = (3,3,0)
		testCase.verifyEqual(p2Proj.coords, [3; 3; 0], "AbsTol", 1e-15);
	end


	function testProjectPointInDifferentFrame(testCase)
		% Test projecting point and line in different frames
		p = Point([2; 1; 1], testCase.frames.world);
		
		% Line in fr1 (which is at [1,1,1] in world with no rotation)
		line = Line( ...
			Point([0; 0; 0], testCase.frames.fr1), ...
			Point([1; 0; 0], testCase.frames.fr1));
		
		pProj = p.project(line);
		% Point [2,1,1] in world = [1,0,0] in fr1
		% Line is X-axis of fr1
		% Projection should be [1,0,0] in fr1 (result is in line's frame)
		testCase.verifyEqual(pProj.coords, [1; 0; 0], "AbsTol", 1e-15);
		testCase.verifyEqual(pProj.ref, testCase.frames.fr1);
	end

	end

end