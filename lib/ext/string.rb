class String;
  def /(s)
    File.join(self, s)
  end

  def blank?
    self == ""
  end

  # Taken from Rails
  def classify
    string = self.underscore
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { $2.capitalize }.gsub('/', '::')
  end

  def underscore 
    word = self.dup
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  def dasherize
    self.underscore.gsub(/_/, '-')
  end

  def to_screen_name
    self.classify.sub(/(screen)*$/i, 'Screen')
  end
end
