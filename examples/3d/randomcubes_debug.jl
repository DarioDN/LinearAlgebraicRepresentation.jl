using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using ViewerGL
GL = ViewerGL
using LinearAlgebra

#include("")
store = []
scaling = .85
V,(VV,EV,FV,CV) = Lar.cuboid([0.25,0.25,0.25],true,[-0.25,-0.25,-0.25])
mybox = (V,CV,FV,EV)
for k=1:10
	size = rand()*scaling
	scale = Lar.s(size,size,size)
	transl = Lar.t(rand(3)...)
	alpha = 2*pi*rand()
	rx = Lar.r(alpha,0,0); ry = Lar.r(0,alpha,0); rz = Lar.r(0,0,alpha)
	rot = rx * ry * rz
	str = Lar.Struct([ transl, scale, rot, mybox ])
	push!(store, Lar.struct2lar(str))
end

str = Lar.Struct(store)
V,CV,FV,EV = Lar.struct2lar(str)
# V = Plasm.normalize3D(V) TODO:  solve MethodError bug

GL.VIEW([ GL.GLPol(V,CV, GL.COLORS[1]) ]);

#preparazione dati
cop_EV = Lar.coboundary_0(EV::Lar.Cells);#stessi dati ma come matrice sparsa
cop_EW = convert(Lar.ChainOp, cop_EV);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');#cobordo 1

FV = Lar.compute_FV( cop_EW, cop_FE )

model = (convert(Lar.Points,W'), FV)

sp_idx = Lar.spaceindex(model)

fs_num = size(cop_FE, 1)

rV = Array{Float64,2}(undef,0,3)

using SparseArrays

rEV = SparseArrays.spzeros(Int8,0,0)

rFE = SparseArrays.spzeros(Int8,0,0)

function pippo(rV,rEV,rFE)
	for sigma in 1:fs_num
		#print(sigma, "/", fs_num, "\r")
		nV, nEV, nFE = Lar.Arrangement.frag_face(W, cop_EW, cop_FE, sp_idx, sigma)
            nV = convert(Lar.Points, nV)
		a,b,c = Lar.skel_merge( rV,rEV,rFE,  nV,nEV,nFE )
		rV=a;  rEV=b;  rFE=c
	end
	return rV, rEV, rFE
end

rV, rEV, rFE = pippo(rV,rEV,rFE)

function merge_vertices(V::Lar.Points, EV::Lar.ChainOp, FE::Lar.ChainOp, err=1e-4)
    vertsnum = size(V, 1)
    edgenum = size(EV, 1)
    facenum = size(FE, 1)
    newverts = zeros(Int, vertsnum)
    # KDTree constructor needs an explicit array of Float64
    V = Array{Float64,2}(V)
    W = convert(Lar.Points, LinearAlgebra.transpose(V))
    kdtree = KDTree(W)
	# remove vertices congruent to a single representative
    todelete = []
    i = 1
    for vi in 1:vertsnum
        if !(vi in todelete)
            nearvs = Lar.inrange(kdtree, V[vi, :], err)
            newverts[nearvs] .= i
            nearvs = setdiff(nearvs, vi)
            todelete = union(todelete, nearvs)
            i = i + 1
        end
    end
    nV = V[setdiff(collect(1:vertsnum), todelete), :]

    # translate edges to take congruence into account
    edges = Array{Tuple{Int, Int}, 1}(undef, edgenum)
    oedges = Array{Tuple{Int, Int}, 1}(undef, edgenum)
    for ei in 1:edgenum
        v1, v2 = EV[ei, :].nzind
        edges[ei] = Tuple{Int, Int}(sort([newverts[v1], newverts[v2]]))
        oedges[ei] = Tuple{Int, Int}(sort([v1, v2]))
    end
    nedges = union(edges)
    # remove edges of zero length
    nedges = filter(t->t[1]!=t[2], nedges)
    nedgenum = length(nedges)
    nEV = spzeros(Int8, nedgenum, size(nV, 1))

    etuple2idx = Dict{Tuple{Int, Int}, Int}()
    for ei in 1:nedgenum
    	begin
        	nEV[ei, collect(nedges[ei])] .= 1
        	nEV
        end
        etuple2idx[nedges[ei]] = ei
    end
    for e in 1:nedgenum
    	v1,v2 = findnz(nEV[e,:])[1]
    	nEV[e,v1] = -1; nEV[e,v2] = 1
    end

    # compute new faces to take congruence into account
    faces = [[
        map(x->newverts[x], FE[fi, ei] > 0 ? oedges[ei] : reverse(oedges[ei]))
        for ei in FE[fi, :].nzind
    ] for fi in 1:facenum]


    visited = []
    function filter_fn(face)

        verts = []
        map(e->verts = union(verts, collect(e)), face)
        verts = Set(verts)

        if !(verts in visited)
            push!(visited, verts)
            return true
        end
        return false
    end

    nfaces = filter(filter_fn, faces)

    nfacenum = length(nfaces)
    nFE = spzeros(Int8, nfacenum, size(nEV, 1))

    for fi in 1:nfacenum
        for edge in nfaces[fi]
            ei = etuple2idx[Tuple{Int, Int}(sort(collect(edge)))]
            nFE[fi, ei] = sign(edge[2] - edge[1])
        end
    end

    return Lar.Points(nV), nEV, nFE
end

rV, rEV, rFE = Lar.Arrangement.merge_vertices(rV, rEV, rFE)

function check_single_non_zero_CSC(A::SparseMatrixCSC)
	sleep_time = 10 #seconds
	temp = 0
	result = []
	for i in range(1,length=size(A,2))
		push!(result, temp)
		temp = 0
		for j in range(1, length=size(A,1))
	        temp+=abs(A[j,i])
		end
	#println(temp)#show column sums
	end
	count = 0
	for k in result
		if isodd(k)
			count+=1
		end
	end
	if count!=0
		println("//////////////////////////////////////////////////////////////////////////////////////////////////////////")
		println("CHECKING SINGLE NON ZERO ELEMENT")
		println("WARNING, THE MATRIX CONTAINS $count COLUMN WITH A SINGLE NON ZERO ELEMENT")
		println("the execution will sleep for $sleep_time seconds")
		println("//////////////////////////////////////////////////////////////////////////////////////////////////////////")
		sleep(sleep_time)
	end
end

bicon_comps = Lar.Arrangement.biconnected_components(rEV)

check_single_non_zero_CSC(rFE)

rV2, rEV2, rFE2, rCF2 = Lar.Arrangement.spatial_arrangement_2(rV, rEV, rFE)

triangulated_faces = Lar.triangulate2D(rV2, [rEV2, rFE2])
FVs = convert(Array{Lar.Cells}, triangulated_faces)
V3 = convert(Lar.Points, rV2')
GL.VIEW( GL.GLExplode(V3,FVs,1.5,1.5,1.5,99,1) );

EVs = Lar.FV2EVs(rEV2, rFE2) # polygonal face fragments
GL.VIEW( GL.GLExplode(V3,EVs,1.5,1.5,1.5,99,1) );
