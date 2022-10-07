# load the include -
include("Include.jl")

# load the training data -
path_to_training_data = joinpath(_PATH_TO_DATA, "Training-Synthetic-dose-response.csv")
training_df = CSV.read(path_to_training_data, DataFrame)

# size of training set -
(R,C) = size(training_df)

# build the model structure -
path_to_model_file = joinpath(_PATH_TO_MODEL, "inducer.net")
model_buffer = read_model_file(path_to_model_file)

# build the default model structure -
model = build_default_model_dictionary(model_buffer)

# # main simulation loop -
# SF = 1e9
# for i ∈ 1:10

    # build new model -
    dd = deepcopy(model)

    # setup static -
    sfa = dd["static_factors_array"]
    # sfa[1] = training_df[i,:TFPI]       # 1 TFPI
    # sfa[2] = training_df[i,:AT]         # 2 AT
    # sfa[3] = (5e-12) * SF               # 3 TF
    # sfa[6] = 0.005                      # 6 TRAUMA

    # grab the multiplier from the data -
    ℳ = dd["number_of_dynamic_states"]
    xₒ = zeros(ℳ)
    # xₒ[1] = 1000       # 1 FII 
    # xₒ[2] = 1000        # 2 FVII 
    # xₒ[3] = 0          # 3 FV
    # xₒ[4] =           # 4 FX
    # xₒ[5] =       # 5 FVIII
    # xₒ[6] = training_df[i, :IX]         # 6 FIX
    # xₒ[7] = training_df[i, :XI]         # 7 FXI
    # xₒ[8] = training_df[i, :XII]        # 8 FXII 
    # xₒ[9] = (1e-14)*SF                  # 9 FIIa
    dd["initial_condition_vector"] = xₒ

    # update α -
    # α = dd["α"]
    # α[1] = 0.061
    # α[2] = 0.70

    # # setup -
    # G = dd["G"]
    # idx = indexin(dd, "FVIIa")
    # G[idx, 4] = 0.1

    # # what is the index of TRAUMA?
    # idx = indexin(dd, "AT")
    # G[idx, 9] = 0.045

# #     # what is the index of TFPI?
# #     idx = indexin(dd, "TFPI")
# #     G[idx, 1] = -0.65

    # run the model -
    global (T,U) = evaluate(dd)
    X = hcat(U...)
    data = [T transpose(X)]

# #     # dump -
# #     path_to_sim_data = joinpath(_PATH_TO_TMP, "SIM-TF-NO-TM-SYN1K-$(i).dat")
# #     CSV.write(path_to_sim_data, Tables.table(data))
# # end

