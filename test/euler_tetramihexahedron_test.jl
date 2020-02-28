using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Tetrahemihexahedron
V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra = V, EV,FV,CV
V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra2 = V, EV,FV,CV
#tetra= Lar.Struct([tetra,tetra2])
twotetra = Lar.Struct([ tetra, Lar.r(0,π,0),tetra2])

V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra3 = V, EV,FV,CV
V, (VV,EV,FV,CV) = Lar.simplex(3, true)
tetra4 = V, EV,FV,CV
#tetra= Lar.Struct([tetra,tetra2])
twotetra2 = Lar.Struct([ tetra3, Lar.r(0,π,0),tetra4])

fourtetra=Lar.Struct([twotetra,Lar.r(0,0,π),twotetra2])
V,EV,FV,CV = Lar.struct2lar(fourtetra)
GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.2)) ]);

cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');#cobordo 1

V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(
	W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
