###### ###### ###### ###### ###### ######
# JSON file handling
###### ###### ###### ###### ###### ######

function read_json(file_path::AbstractString)
    iscompressed = endswith(file_path, ".json.gz")
    io = iscompressed ? GZip.open(file_path, "r") : open(file_path, "r")
    data = JSON3.read(io; allow_inf=true)
    close(io)
    return data
end

function write_json(file_path::AbstractString, data::Dict{Symbol,<:Any})::Nothing
    io = open(file_path, "w")
    JSON3.pretty(io, data; allow_inf=true)
    close(io)
    return nothing
end

macro JSON_EXT()
    return (".json", ".json.gz")
end

isjson(path::AbstractString) = any(endswith.(path, @JSON_EXT))

# Fetch all json files in the directory
function get_json_files(path::AbstractString)
    return filter(x -> any(endswith.(x, @JSON_EXT)), readdir(path))
end