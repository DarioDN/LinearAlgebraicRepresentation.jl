using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Cubohemioctahedron prototype TODO
a=0.135#allarga sopra
b=0.268#stringe sotto
c=0.5
d=1
h=0.709219858
V=[0 b d c -a;0 d b -a c; 0 0 0 h h]
VV=[[1],[2],[3],[4],[5]]
EV=[[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5],[2,5]]
FV=[[1,2,3],[1,3,4],[1,2,5],[1,4,5]]#,[2,3,4,5]
CV=[[1, 2, 3, 4, 5]]
tetra = V,EV,FV,CV
twotetra = Lar.Struct([ tetra ,Lar.r(0,0,2π/3),tetra])
threetetra = Lar.Struct([ twotetra ,Lar.r(0,0,4π/3),tetra])
sixtetra=Lar.Struct([ threetetra ,Lar.r(0,π,0)*Lar.r(0,0,853π/1024), threetetra])
# octatetra=Lar.Struct([ fourtetra ,Lar.r(0,0,π/2), fourtetra])
finaltetra = Lar.Struct([ sixtetra ])
V,EV,FV,CV = Lar.struct2lar(finaltetra)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1)) ,GL.GLFrame]);

cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');#cobordo 1

V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(
	W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
