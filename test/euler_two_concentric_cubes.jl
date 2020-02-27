using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using SparseArrays;
using ViewerGL, LinearAlgebra
GL = ViewerGL

store=[]
V, (VV, EV, FV, CV) = Lar.cuboid([1,1,1], true);
mybox = (V,CV,FV,EV);
str = Lar.Struct([ mybox ])
obj = Lar.struct2lar(str)
push!(store, obj)
V, (VV, EV, FV, CV) = Lar.cuboid([0.5,0.5,0.5], true);
mybox = (V,CV,FV,EV);
transl = Lar.t(0.25,0.25,0.25)
str = Lar.Struct([ transl, mybox ])
obj = Lar.struct2lar(str)
push!(store, obj)
str = Lar.Struct(store);
V,CV,FV,EV = Lar.struct2lar(str);
GL.VIEW([ GL.GLPol(V,CV, GL.COLORS[1]) ]);
cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W=convert(Lar.Points,V')
V, copEV, copFE, copCF = Lar.Arrangement.spatial_arrangement(W::Lar.Points, cop_EV::Lar.ChainOp, cop_FE::Lar.ChainOp);
triangulated_faces = Lar.triangulate2D(V, [copEV, copFE]);
FVs = convert(Array{Lar.Cells}, triangulated_faces);
VVV = convert(Lar.Points, V');
try
    GL.VIEW( GL.GLExplode(VVV,FVs,1,1,1,99,1) );
catch
    e="visualizzazione errata causa triangolazione errata"
    @show FVs
    println("La presenza di array vuoti indica la mal riuscita della triangolazione")
finally
    temp=[]
    for x in FVs
       if !isempty(x)
           push!(temp, x)
       end
    end
    GL.VIEW( GL.GLExplode(VVV,temp,1,1,1,99,1) );
end
