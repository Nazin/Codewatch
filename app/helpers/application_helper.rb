module ApplicationHelper

  ActionView::Base.default_form_builder = StandardFormBuilder

  #uber form_for
  def cw_form_for(name, *args, &block)

    options = args.extract_options!

    content_tag("div", form_for(name, *(args << options.merge(:builder => StandardFormBuilder)), &block), :class => "codewatchForm")
  end

  #return page specific logo
  def full_title subtitle

    base = "Codewatch.pl"

    if not @company.nil?
      base = @company.name + " :: " + base
    end

    if not @project.nil? and !@project.new_record?
      base = @project.name + " :: " + base
    end

    if subtitle.blank?
      base
    else
      subtitle + " :: " + base
    end
  end

  #return logo image
  def logo
    image_tag("logo.png", alt: "Sample App", class: "round")
  end

  def admin?
    role = UserCompany::Role.new @company, current_user
    role.admin?
  end

  def owner?
    role = UserCompany::Role.new @company, current_user
    role.owner?
  end

  def user?
    role = UserCompany::Role.new @company, current_user
    role.user?
  end
end
