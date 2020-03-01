using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Octahemioctahedron
a=0.5
b=0.735
V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra = [0 1 a a;0 0 a*-1 a; 0 0 b b], EV,FV,CV
V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra2 = [0 1 a a;0 0 a*-1 a; 0 0 b b], EV,FV,CV
twotetra = Lar.Struct([ tetra ,Lar.r(π,0,0),tetra2])
fourtetra=Lar.Struct([ twotetra ,Lar.r(0,0,π), twotetra])
octatetra=Lar.Struct([ fourtetra ,Lar.r(0,0,π/2), fourtetra])
V,EV,FV,CV = Lar.struct2lar(octatetra)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1))]);

# cop_EV = Lar.coboundary_0(EV::Lar.Cells);
# cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
# W = convert(Lar.Points, V');#cobordo 1
#
# V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(
# 	W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
