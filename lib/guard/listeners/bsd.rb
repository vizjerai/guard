module Guard

  # Listener implementation for BSD `cool.io`.
  #
  class Bsd < Listener

    # Initialize the Listener.
    #
    def initialize(*)
      super
      @coolio = Cool.io::Loop.new
    end

    # Start the listener.
    #
    def start
      super
      worker.run
    end

    # Stop the listener.
    #
    def stop
      worker.stop
      super
    end

    def self.usable?
      require 'cool.io'
      if !defined?(Coolio::VERSION) || (defined?(Gem::Version) &&
          Gem::Version.new(Coolio::VERSION) < Gem::Version.new('1.1.0'))
        UI.info 'Please update cool.io (>= 1.1.0)'
        false
      else
        true
      end
    rescue LoadError
      UI.info 'Please install cool.io gem for BSD support'
      false
    end

    if Bsd.usable?
      class GuardWatcher < Cool.io::StatWatcher
        def initialize(path, interval = nil, &callback)
          super(path, interval)
          @callback = callback
        end

        def on_change(previous, current)
          @callback.call(path)
        end
      end
    end

    private

    # Watch the given directory for file changes.
    #
    # @param [String] directory the directory to watch
    #
    def watch(directory)
      GuardWatcher.new(directory) do |file_path|
        paths = [File.dirname(file_path)]
        files = modified_files(paths, :all => true)
        @callback.call(files) unless files.empty?
      end.attach(worker)
    end

    # Get the listener worker.
    #
    def worker
      @coolio
    end

  end

end
