module Tres
  class CantParseJSONFile < RuntimeError; end
  class NoSuchFile < RuntimeError; end
  class TemplateExistsError < RuntimeError; end
  class ScriptExistsError < RuntimeError; end
end