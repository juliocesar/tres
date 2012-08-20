# coding: utf-8
$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'logger'
require 'json/pure'
require 'ext/string'
require 'ext/filemethods'
require 'tres/app'
require 'tres/asset_packager'
require 'tres/template_compiler'
require 'tres/server'
require 'tres/logger'
require 'tres/errors'

module Tres
  OUTPUT_FORMAT = "   → %s"

  class << self
    def quiet!
      @quiet = true
    end
    
    def quiet?
      !!@quiet
    end
    
    def verbose!
      @quiet = false
    end
    
    def say something
      STDOUT.puts(OUTPUT_FORMAT % something) unless quiet?
      yield if block_given?
    end

    def say_progress something, done = '✔'.colorize(:green)
      STDOUT.write(OUTPUT_FORMAT % something + "  ") unless quiet?
      yield if block_given?
      STDOUT.puts done unless quiet?
    end

    def error message
      STDERR.puts message unless quiet?
    end

    def root
      @root ||= File.expand_path File.dirname(__FILE__)/'..'
    end

    def templates_dir
      root/'templates'
    end

    def styles_dir
      root/'sass'
    end

    def scripts_dir
      root/'javascripts'
    end
  end
  VERSION = File.read Tres.root/'VERSION'
end
