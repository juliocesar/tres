module Tres
  class TemplateRenderer
    def initialize options = {}
      @root = options[:path].join('templates')
    end
  end
end