require "open3"

module Mcl
  class Server
    module IPC
      def ipc_setup
        app.graceful do
          app.log.debug "[SHUTDOWN] Closing IPC handles..."
          @_ipc_stdin.try(:close) rescue nil
          @_ipc_stdouterr.try(:close) rescue nil
        end
      end

      def ipc_spawn
        app.graceful do
          app.log.info "[SHUTDOWN] Stopping minecraft server..."
          if @_ipc_thread
            begin
              app.server.update_status :stopping
              Process.kill("TERM", @_ipc_thread.pid)

              app.log.debug "[SHUTDOWN] waiting up to 30 seconds for the minecraft server to stop..."
              c = 0
              while alive? && c < 30
                c += 1
                sleep 1
              end
            rescue Errno::ESRCH
              app.log.debug "[SHUTDOWN] #{$!.class.name}: #{$!.message}"
            end

            if alive?
              app.log.debug "[SHUTDOWN] killing minecraft server..."
              begin
                Process.kill("KILL", @_ipc_thread.pid)
              rescue Errno::ESRCH
                app.log.debug "[SHUTDOWN] #{$!.class.name}: #{$!.message}"
              end
            end
          end
          app.server.update_status :stopped unless alive?
        end

        if $_ipc_reattach
          app.log.info "[IPC] reattaching handle..."
          @_ipc_stdin, @_ipc_stdouterr, @_ipc_thread = $_ipc_reattach
          $_ipc_reattach = nil
          app.log.debug "[IPC] server running with pid #{@_ipc_thread.pid}"
        else
          app.log.info "[IPC] starting minecraft server..."
          @_ipc_stdin, @_ipc_stdouterr, @_ipc_thread = Open3.popen2e(%{cd "#{app.server.root}" && exec #{app.config["launch_cmd"]}})
          app.log.debug "[IPC] server running with pid #{@_ipc_thread.pid}"
        end
      end

      def ipc_invoke command
        return unless @_ipc_stdin.respond_to?(:puts)
        app.log.debug command
        @_ipc_stdin.puts(command)
        @_ipc_stdin.flush
      end

      def ipc_read &block
        block.call @_ipc_stdouterr.gets
      end

      def ipc_died?
        @_ipc_thread && !@_ipc_thread.alive?
      end

      def ipc_restart

      end

      def ipc_detach
        app.log.info "[IPC] detaching handle..."
        $_ipc_reattach = [@_ipc_stdin, @_ipc_stdouterr, @_ipc_thread]
        @_ipc_stdin, @_ipc_stdouterr, @_ipc_thread = nil, nil, nil
      end
    end
  end
end