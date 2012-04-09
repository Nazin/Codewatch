class StandardFormBuilder < ActionView::Helpers::FormBuilder

	FIELDS = %w(radio_button check_box text_field text_area password_field select file_field collection_select email_field date_select)
	
	def submit(label, *args)
		options = args.extract_options!
		new_class = options[:class] || "send"
		super(label, *(args << options.merge(:class => new_class)))
	end
 
	def self.create_tagged_field(method_name)

		define_method(method_name) do |label, *args|

			options = args.extract_options!
 
			custom_label = options[:label] || label.to_s.humanize
			errors = ''
 
			if @object && label.present? && @object.errors.keys.include?(label) && @object.errors[label].any?

				@object.errors[label].each { |item| errors += @template.content_tag("li", custom_label + " " + item) }
				errors = @template.content_tag("ul", errors.html_safe, :class => 'errors')
			end
		  
			@template.content_tag("label", custom_label, :for => "#{@object_name}_#{label}") + @template.content_tag("div", super(label, *(args << options)) + errors, :class => 'e')
		end
	end
 
	FIELDS.each do |name|
		create_tagged_field(name)
	end
end
