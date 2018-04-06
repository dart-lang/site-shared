# Inspired by: https://willnorris.com/2014/12/watching-symlinked-directories-with-jekyll

require 'find'
require 'jekyll-watch'
require 'listen'

module Jekyll
  module Watcher
    def build_listener(site, options)
      dirs = [options['source']]
      symLinkedSources = options['symlinked-sources']
      dirs += symLinkedSources if symLinkedSources
      # puts ">> will watch #{dirs}"
      Listen.to(
        *dirs,
        :ignore => listen_ignore_paths(options),
        :force_polling => options['force_polling'],
        &(listen_handler(site))
      )
    end
  end
end