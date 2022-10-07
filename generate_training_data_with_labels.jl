# Where are we?
_BASE_PATH = pwd()
_PATH_TO_DATA = joinpath(_BASE_PATH, "data")

# Package that we need -
using DataFrames
using CSV
using Distributions
using Statistics
using LinearAlgebra

# load the actual data -
path_to_experimental_data = joinpath(_PATH_TO_DATA, "Dose_response.csv")
full_df = CSV.read(path_to_experimental_data, DataFrame)
(number_of_records, _) = size(full_df) 

# what are the col names? (exclude subject id and visit id)
data_col_symbols = Symbol.(names(full_df)[1:end])
number_of_fields = length(data_col_symbols)

# setup scale factor dictionary to convert to concentration units -
SF = 1e6    #micromolar
scale_factor_dict = Dict()
scale_factor_dict[:inducer] = 1000.0    # mM
scale_factor_dict[:protein] = 1.0       # uM
#scale_factor_dict[:proteinsd] =1.0


# initialize -
transformed_df = DataFrame()
for rᵢ ∈ 1:number_of_records


    tmp = Vector()
    for fᵢ ∈ 1:number_of_fields
        field_symbol = data_col_symbols[fᵢ]
        value = scale_factor_dict[field_symbol]*full_df[rᵢ,field_symbol]
        push!(tmp, value)
    end

    # create new record -
    transformed_tuple = (
        inducer = tmp[1], 
        protein = tmp[2],
        #proteinsd = tmp[3],
     
    )
    push!(transformed_df, transformed_tuple)
end

# dump sample data to disk -
path_to_transformed_data = joinpath(_PATH_TO_DATA, "Training-dose-response-Transformed-w-Labels.csv")
CSV.write(path_to_transformed_data, transformed_df)