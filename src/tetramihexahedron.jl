using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

#Tetrahemihexahedron
"""
Return the Lar.Struct of tetrahemihexahedron
"""
function tetrahemihexahedron()
	V, (VV,EV,FV,CV) = Lar.simplex(3, true)
	tetra = V, EV,FV,CV
	twotetra = Lar.Struct([ tetra, Lar.r(0,π,0),tetra])
	V,EV,FV,CV = Lar.struct2lar(Lar.Struct([twotetra,Lar.r(0,0,π),twotetra]))
	return Lar.Struct([(V,collect(Set(EV)),FV,CV)])
end
