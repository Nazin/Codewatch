class DiffValidator < ActiveModel::Validator

  def validate record
    @record = record
    validate_urls_and_codes
  end


  private

  def validate_urls_and_codes
    if urls_blank? && codes_blank?
      @record.errors[:base]="Either urls or codes must be non blank"
    elsif no_non_blank?
      @record.errors[:base]="Both urls and code are non blank, choose one"
    end
  end

  def no_non_blank?
    !urls_blank? && !codes_blank?
  end

  def urls_blank?
    @record.url_a.blank? && @record.url_b.blank?
  end

  def codes_blank?
    @record.code_a.blank? && @record.code_b.blank?
  end


end
