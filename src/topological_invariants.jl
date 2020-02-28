function test_eulero(V, copEV, FE)
    if !isempty(V)
        vertex=size(V,1)
    else
        println("WARNING!!! V matrix is empty!!!")
    end
    if !isempty(copEV)
        edges=size(copEV,1)
    else
        println("WARNING!!! EV matrix is empty!!!")
    end
    if !isempty(FE)
        faces = size(FE,1)
    else
        println("WARNING!!! FE matrix is empty!!!")
    end
    bc=size(Lar.Arrangement.biconnected_components(copEV))[1]
    println("EULERIAN CHARACTERISTIC-->$(vertex-edges+faces) BICON COMPS==$(bc) VERTEX = $(vertex) EDGES = $(edges) FACES = $(faces)")
end

function test_eulero2(V, copEV, FE)
    edges=Set{Int64}()
    vertices=Set{Int64}()
    counter=0
    dict=Dict()
    array=[]
    array2=[]
    ciEV=[]
    ciFE=[]
    if !isempty(V)
        vertex=size(V)[1]
    end
    if !isempty(copEV)
        ciEV=findall(!iszero,copEV);
    end
    if !isempty(FE)
        ciFE=findall(!iszero,FE);
    end
    for j in 1:size(FE)[1]
        for i in ciFE
            if i[1]==j
                push!(array,[i[1],i[2]])
            end
        end
    end
    for j in 1:size(copEV)[1]
        for i in ciEV
            if i[1]==j
                push!(array2,[i[1],i[2]])
            end
        end
    end
    prev=0
    for x in array
        if prev!=x[1]
            if length(vertices)!==length(edges)
                println("WARNING !!! TEST FAILED")
            end
            vertices=Set{Int64}()
            edges=Set{Int64}()
        end
        for y in array2
            if x[2]==y[1]
                push!(edges,y[1])
                push!(vertices,y[2])
            end

        end
        prev=x[1]
    end
end
