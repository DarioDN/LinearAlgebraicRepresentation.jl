using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Octahemioctahedron prototype DEBUG
"""
Return the Lar.Struct of octahemioctahedron prototype
"""
function octahemioctahedron()
    a=0.5
    b=0.735
    V, (VV,EV,FV,CV) = Lar.simplex(3, true)
    tetra = [0 1 a a;0 0 a*-1 a; 0 0 b b], EV,FV,CV
    twotetra = Lar.Struct([ tetra ,Lar.r(π,0,0),tetra])
    fourtetra=Lar.Struct([ twotetra ,Lar.r(0,0,π), twotetra])
    Lar.Struct([ fourtetra ,Lar.r(0,0,π/2), fourtetra])
    V,EV,FV,CV = Lar.struct2lar(Lar.Struct([ fourtetra ,Lar.r(0,0,π/2), fourtetra]))
    return Lar.Struct([(V,collect(Set(EV)),FV,CV)])
end
