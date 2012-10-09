class CompanyHeaderCell < UnauthorizedUserHeaderCell

  helper SessionsHelper

  def display(args)
    @company = args[:company]
    @project = args[:project]
    @admin = args[:admin]
    render
  end

  def cookies
    @cookies
  end


end
