class String;
  def /(s)
    File.join(self, s)
  end

  def blank?
    self == ""
  end

  # Taken from Rails
  def classify
    string = self.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { $2.capitalize }.gsub('/', '::')
  end
end
