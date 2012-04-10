module ApplicationHelper

	ActionView::Base.default_form_builder = StandardFormBuilder

	def cw_form_for(name, *args, &block)

		options = args.extract_options!
		
		content_tag("div", form_for(name, *(args << options.merge(:builder => StandardFormBuilder)), &block), :class => "codewatchForm")
	end
	
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
