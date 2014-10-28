module Mcl
  class ConsoleServer
    class Session
      attr_reader :server, :thread, :socket, :shell

      def initialize(server, thread, socket)
        @server = server
        @thread = thread
        @socket = socket
        @shell = Shell.new(self)
      end

      def cputs *msg
        msg.each {|m| @socket << "#{m}\r\n" }
        @socket.flush rescue IOError
      end

      def cprint *msg
        msg.each {|m| @socket << "#{m}" }
        @socket.flush rescue IOError
      end

      def helo!
        @server.app.log.info "[ConsoleServer] Client #{client_id} connected"
        @shell.hello
      end

      def peer
        @peer ||= Socket.unpack_sockaddr_in(@socket.getpeername).reverse
      end

      def client_id
        "#{peer.join(":")}"
      end

      def terminate ex = nil, silent = false
        unless silent
          reason = ""
          reason << ex if ex.is_a?(String)
          reason << "#{ex.class}: #{ex.message}" if ex.is_a?(Exception)
          reason = reason.presence || "generic"
          @shell.goodbye(reason)
          @server.app.log.info "[ConsoleServer] Client #{client_id} disconnected (#{reason})"
        end
        @thread.try(:kill)
      end

      def loop!
        loop do
          begin
            # Returns nil on EOF
            while line = @socket.gets
              @shell.input(line.chomp!)
            end
          rescue
            msg = "[ConsoleServer] #{client_id} terminated: #{$!.class.name}: #{$!.message}"
            if $!.message =~ /closed stream/i
              @server.app.devlog(msg)
            else
              @server.app.handle_exception($!) {|ex| @server.app.log.error(msg) }
            end
            terminate($!, true)
          ensure
            @socket.close
            @server.vanish(self)
          end
        end
      end
    end
  end
end
