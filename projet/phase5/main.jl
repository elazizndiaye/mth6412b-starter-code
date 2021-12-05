# Programme principal
using Printf, Random, FileIO, Images, ImageView, ImageMagick

include("im_recons.jl")

""" Programme principal. """
function main(; index_to_run = [])
    if index_to_run == []
        index_to_run = Vector(1:9)
    end
    for index in index_to_run
        if index == 1 # "abstract-light-painting"
            # Weight RSL = 12539731
            # Weight HK = 12314767
            instance_tsp = "./shredder-julia/tsp/instances/abstract-light-painting.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/abstract-light-painting.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 56, inverse_tour_flag = true)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 206, hk_step = 700, hk_n_iterations = 25, inverse_tour_flag = true)
        elseif index == 2 # "alaska-railroad"
            # Weight RSL = 7978214
            # Weight HK = 7667914
            instance_tsp = "./shredder-julia/tsp/instances/alaska-railroad.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/alaska-railroad.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 228, inverse_tour_flag = false)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 560, hk_step = 600, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 3 # "blue-hour-paris"
            # Weight RSL = 4282232
            # Weight HK = 3946200
            instance_tsp = "./shredder-julia/tsp/instances/blue-hour-paris.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/blue-hour-paris.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 173, inverse_tour_flag = true)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 553, hk_step = 500, hk_n_iterations = 20, inverse_tour_flag = true)
        elseif index == 4 # "lower-kananaskis-lake"
            # Weight RSL = 4398702
            # Weight HK = 4233817
            instance_tsp = "./shredder-julia/tsp/instances/lower-kananaskis-lake.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/lower-kananaskis-lake.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 84, inverse_tour_flag = true)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 161, hk_step = 600, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 5 # "marlet2-radio-board"
            # Weight RSL = 9261640
            # Weight HK = 8864812
            instance_tsp = "./shredder-julia/tsp/instances/marlet2-radio-board.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/marlet2-radio-board.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 219, inverse_tour_flag = true)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 219, hk_step = 500, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 6 # "nikos-cat"
            # Weight RSL = 3375996
            # Weight HK = 3041738
            instance_tsp = "./shredder-julia/tsp/instances/nikos-cat.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/nikos-cat.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 29, inverse_tour_flag = true)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 29, hk_step = 500, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 7 # "pizza-food-wallpaper"
            # Weight RSL = 5283276
            # Weight HK = 5041336
            instance_tsp = "./shredder-julia/tsp/instances/pizza-food-wallpaper.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/pizza-food-wallpaper.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 273, inverse_tour_flag = false)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 403, hk_step = 600, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 8 # "the-enchanted-garden"
            # Weight RSL = 20169824
            # Weight HK = 19914400
            instance_tsp = "./shredder-julia/tsp/instances/the-enchanted-garden.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/the-enchanted-garden.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 358, inverse_tour_flag = false)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 476, hk_step = 600, hk_n_iterations = 20, inverse_tour_flag = false)
        elseif index == 9 # "tokyo-skytree-aerial"
            # Weight RSL = 13785352
            # Weight HK = 13610038
            instance_tsp = "./shredder-julia/tsp/instances/tokyo-skytree-aerial.tsp"
            instance_shuffled = "./shredder-julia/images/shuffled/tokyo-skytree-aerial.png"
            rsl_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 20, inverse_tour_flag = false)
            hk_reconstruct_image(instance_tsp, instance_shuffled; index_node_source = 199, hk_step = 700, hk_n_iterations = 20, inverse_tour_flag = false)
        end
    end
end

# Executer toutes les instances
main(; index_to_run = 4)
#main()
