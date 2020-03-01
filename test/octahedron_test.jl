using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Octahedron
octahedron = Lar.octahedron(1)
V,EV,FV,CV = Lar.struct2lar(octahedron)
GL.VIEW([ GL.GLGrid(V,FV), GL.GLFrame]);
EV=collect(Set(EV))
cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);

W = convert(Lar.Points, V');

V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
triangulated_faces = Lar.triangulate2D(V, [copEV, copFE]);
FVs = convert(Array{Lar.Cells}, triangulated_faces);
V = convert(Lar.Points, V');
GL.VIEW( GL.GLExplode(V,FVs,1.5,1.5,1.5,99,1) );


EVs = Lar.FV2EVs(copEV, copFE); # polygonal face fragments
GL.VIEW( GL.GLExplode(V,EVs,1.5,1.5,1.5,99,1) );

#Octahedron whit arbitrry height
octahedron = Lar.octahedron(1,1)
V,EV,FV,CV = Lar.struct2lar(octahedron)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1)), GL.GLFrame]);

#Regular base octahedron
octahedron = Lar.rectangularbase_octahedron(1,2,1)
V,EV,FV,CV = Lar.struct2lar(octahedron)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1)), GL.GLFrame]);
