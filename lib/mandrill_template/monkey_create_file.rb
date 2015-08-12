class Thor
  module Actions
    class CreateFile
      class_eval do
        def identical?
          exists? && File.binread(destination).force_encoding(render.encoding) == render
        end
      end
    end
  end
end
