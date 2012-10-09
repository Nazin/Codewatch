module TasksHelper
  def state task
    Task::State::to_hash[task.state]
  end

  def priority task
    Task::Priority::to_hash[task.priority]
  end

end
