using Random
using FIGlet

# Seed the random number generator
Random.seed!(42);

"""
Generates `pixels` dataset
"""
function generate_pixels_dataset()
  tasks = collect(1:10)
  sizes = collect(1:5)
  trials = collect(1:10)

  jobs = [(size,task,trial) for size in sizes for task in tasks for trial in trials]

  for (size, task, trial) in jobs
  
    open("e3-pixels/data/$size-$task-$trial.pl", "w+") do io
      write(io, "TODO")
    end
  end
end

generate_pixels_dataset()