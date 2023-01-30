using Random

# Seed the random number generator
Random.seed!(42);

"""
Generates a random integer coordinate with both x and y in the [1, size]
"""
function rand_coord(size)
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
function rand_state(size)
    robo_pos = rand_coord(size)
    ball_pos = rand_coord(size)
    holding = if (robo_pos == ball_pos) rand_flag() else 0 end
    return "w($robo_pos,$ball_pos,$holding,$size)"
end

"""
Generates `robots` dataset
"""
function generate_robots_dataset()
  num_tasks = 10
  tasks = collect(0:num_tasks)
  sizes = [2,4,6,8,10]
  trials = [1,2,3,4,5,6,7,8,9,10]
  jobs = [(size,task,trial) for size in sizes for task in tasks for trial in trials]

  for (size, task, trial) in jobs
    s1 = rand_state(size)
    s2 = rand_state(size)
  
    open("e1-robots/data/$size-$task-$trial.pl", "w+") do io
      write(io, "pos($s1,$s2).\n")
    end
  end
end

generate_robots_dataset()