using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Octahemioctahedron prototype TODO
function octahemioctahedron()
    a=0.5
    b=0.735
    V, (VV,EV,FV,CV) = Lar.simplex(3, true)
    tetra = [0 1 a a;0 0 a*-1 a; 0 0 b b], EV,FV,CV
    V, (VV,EV,FV,CV) = Lar.simplex(3, true)
    tetra2 = [0 1 a a;0 0 a*-1 a; 0 0 b b], EV,FV,CV
    twotetra = Lar.Struct([ tetra ,Lar.r(π,0,0),tetra2])
    fourtetra=Lar.Struct([ twotetra ,Lar.r(0,0,π), twotetra])
    return Lar.Struct([ fourtetra ,Lar.r(0,0,π/2), fourtetra])
end
