using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Tetrahemihexahedron
function tetrahemihexahedron()

	V, (VV,EV,FV,CV) = Lar.simplex(3, true)
	tetra = V, EV,FV,CV
	twotetra = Lar.Struct([ tetra, Lar.r(0,π,0),tetra])
	return Lar.Struct([twotetra,Lar.r(0,0,π),twotetra])
end
