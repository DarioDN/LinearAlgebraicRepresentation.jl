using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using SparseArrays;
using ViewerGL, LinearAlgebra
GL = ViewerGL

V = [0.6899599 0.502989 0.8326865 0.6457156 0.8586244 0.6716535 1.001351 0.8143801 0.5361978 0.3644763 0.5783999 0.4066785 0.5468975 0.375176 0.5890997 0.4173782;
 0.2417823 0.3845089 0.4884655 0.6311921 0.1912528 0.3339794 0.4379359 0.5806626 0.2867544 0.3289566 0.4588041 0.5010062 0.2854601 0.3276623 0.4575098 0.4997119;
 0.0757586 0.2444231 0.0252291 0.1938936 0.3054883 0.4741529 0.2549588 0.4236233 0.1554979 0.1661976 0.1542036 0.1649033 0.3323244 0.3430241 0.3310301 0.3417298]

CV = Array{Int64,1}[[1, 2, 3, 4, 5, 6, 7, 8], [9, 10, 11, 12, 13, 14, 15, 16]]

FV = Array{Int64,1}[[1, 2, 3, 4], [5, 6, 7, 8], [1, 2, 5, 6], [3, 4, 7, 8], [1, 3, 5, 7], [2, 4, 6, 8], [9, 10, 11, 12], [13, 14, 15, 16], [9, 10, 13, 14], [11, 12, 15, 16], [9, 11, 13, 15], [10, 12, 14, 16]]

EV = Array{Int64,1}[[1, 2], [3, 4], [5, 6], [7, 8], [1, 3], [2, 4], [5, 7], [6, 8], [1, 5], [2, 6], [3, 7], [4, 8], [9, 10], [11, 12], [13, 14], [15, 16], [9, 11], [10, 12], [13, 15], [14, 16], [9, 13], [10, 14], [11, 15], [12, 16]]

GL.VIEW([ GL.GLPol(V,CV, GL.COLORS[1]) ]);
cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');#cobordo 1
V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
triangulated_faces = Lar.triangulate2D(V, [copEV, copFE]);
FVs = convert(Array{Lar.Cells}, triangulated_faces);
VVV = convert(Lar.Points, V');
GL.VIEW( GL.GLExplode(VVV,FVs,1,1,1,99,1) );
EVs = Lar.FV2EVs(copEV, copFE); # polygonal face fragments
GL.VIEW( GL.GLExplode(VVV,EVs,1.5,1.5,1.5,99,1) );
