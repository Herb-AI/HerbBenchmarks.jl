using Random

# Seed the random number generator
Random.seed!(42);

"""
Generates a random integer coordinate with both x and y in the [1, size]
"""
function rand_coord(size::Integer)::String
    x = rand(1:size)
    y = rand(1:size)
    return "$x,$y"
end


function rand_flag()
    return rand(0:1)
end


"""
Generates a random `robots` state
"""
function rand_state(size::Integer)::String
    robo_pos = rand_coord(size)
    ball_pos = rand_coord(size)
    holding = if (robo_pos == ball_pos) rand_flag() else 0 end
    return "w($robo_pos,$ball_pos,$holding,$size)"
end


"""
Generate and write single datapoints given world size, task and trial number. Useful for generating specific worlds.
"""
function generate_single_robot_datapoint(size, task, trial)
    s1 = rand_state(size)
    s2 = rand_state(size)
  
    open("e1-robots/data/$size-$task-$trial.pl", "w+") do io
      write(io, "pos($s1,$s2).\n")
    end
end


"""
Generate entire `robots` dataset.
"""
function generate_robots_dataset(max_size=10, n_tasks=10, n_trials=10)
  sizes = 1:2:max_size
  trials = 1:n_trials
  tasks = 1:n_tasks

  jobs = [(size,task,trial) for size in sizes for task in tasks for trial in trials]

  for (size, task, trial) in jobs
      generate_single_robot_datapoint(size, task, trial)
  end
end

generate_robots_dataset()
