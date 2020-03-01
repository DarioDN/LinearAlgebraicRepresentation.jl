using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using ViewerGL
GL = ViewerGL

function octahedron(l)
    a = l * (sqrt(3) / 2)
    h = sqrt(a^2 - ((l / 2)^2))
    #h=0.70710678118654
    V = [0 l 0 l l / 2; 0 0 l l l / 2; 0 0 0 0 h]
    VV = [[1], [2], [3], [4], [5]]
    EV = [[1, 2], [3, 4], [4, 5], [1, 5], [1, 5], [2, 5], [3, 5], [4, 5]]
    FV = [[1, 2, 5], [1, 3, 5], [3, 4, 5], [2, 4, 5]]
    CV = [[1, 2, 3, 4, 5]]
    tetrahedron = V, EV, FV, CV
    return octahedron =
        Lar.Struct([tetrahedron, Lar.t(0, l, 0), Lar.r(π, 0, 0), tetrahedron])
end

function octahedron(l, h)
    V = [0 l 0 l l / 2; 0 0 l l l / 2; 0 0 0 0 h]
    VV = [[1], [2], [3], [4], [5]]
    EV = [[1, 2], [3, 4], [4, 5], [1, 5], [1, 5], [2, 5], [3, 5], [4, 5]]
    FV = [[1, 2, 5], [1, 3, 5], [3, 4, 5], [2, 4, 5]]
    CV = [[1, 2, 3, 4, 5]]
    tetrahedron = V, EV, FV, CV
    return octahedron =
        Lar.Struct([tetrahedron, Lar.t(0, l, 0), Lar.r(π, 0, 0), tetrahedron])
end

function rectangularbase_octahedron(ab, da, h)
    V = [0 ab 0 ab ab / 2; 0 0 da da da / 2; 0 0 0 0 h]
    V2 = [0 ab 0 ab ab / 2; 0 0 da da da / 2; 0 0 0 0 -h]
    VV = [[1], [2], [3], [4], [5]]
    EV = [[1, 2], [3, 4], [4, 5], [1, 5], [1, 5], [2, 5], [3, 5], [4, 5]]
    FV = [[1, 2, 5], [1, 3, 5], [3, 4, 5], [2, 4, 5]]
    CV = [[1, 2, 3, 4, 5]]
    tetrahedron = V, EV, FV, CV
    tetrahedron2 = V2, EV, FV, CV
    return octahedron = Lar.Struct([tetrahedron, tetrahedron2])
end

a = Lar.octahedron(1)
V, EV, FV, CV = Lar.struct2lar(a)
#GL.VIEW([ GL.GLGrid(V,FV, GL.Point4d(1,1,1,0.1)),GL.GLFrame]);
GL.VIEW([GL.GLGrid(V, FV, GL.Point4d(1, 1, 1, 0.1))]);
