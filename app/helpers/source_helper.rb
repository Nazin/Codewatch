module SourceHelper

  def tree el

    if @path.nil?
      path = el.name
    else
      path = File.join @path, el.name
    end

    path.gsub! '/', '_'

    link_to el.name, project_branch_tree_path(@project.id, @branch, path)
  end

  def blob el

    if @path.nil?
      link_to el.name, project_branch_blob_path(@project.id, @branch, el.id)
    else
      @path.gsub! '/', '_'
      link_to el.name, project_parent_branch_blob_path(@project.id, @branch, @path, el.id)
    end
  end

  def up_dir

    parts = @path.reverse.split File::SEPARATOR, 2

    if parts.length == 2
      path = parts[1].reverse
    else
      path = ''
    end

    link_to '..', project_branch_tree_path(@project.id, @branch, path)
  end
end
