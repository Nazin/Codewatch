module ApplicationHelper
  
  #return page specific logo
  def full_title subtitle
    base = "Codewatch.pl"
    if subtitle.blank?
      base
    else
      base + " | " + subtitle
    end
  end

  #return logo image
  def logo
    image_tag("logo.png", alt: "Sample App", class: "round")
  end
end
