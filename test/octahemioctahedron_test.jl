using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Test spatial_arrangement on octahemioctahedron DEBUG
octahemioctahedron = Lar.octahemioctahedron()
V,EV,FV,CV = Lar.struct2lar(octahemioctahedron)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1))]);

cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');#cobordo 1

V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(
W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
