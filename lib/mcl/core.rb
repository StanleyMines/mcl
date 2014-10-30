module Mcl
  # core dependencies
  require "benchmark"
  require "digest/sha1"
  require "fileutils"
  require "find"
  require "monitor"
  require "net/http"
  require "open-uri"
  require "open3"
  require "optparse"
  require "rbconfig"
  require "socket"
  require "thread"
  require "yaml"

  # gems
  require "pry"
  require "active_record"

  # 3rd party
  require "#{ROOT}/lib/massive_craft/s2b"
  require "#{ROOT}/lib/bmonkeys/string_expand_range"

  # application
  "#{ROOT}/lib/mcl".tap do |lib|
    require "#{lib}/windows_hacks" if Mcl.windows?
    require "#{lib}/id2mcn"
    require "#{lib}/multi_io"
    require "#{lib}/promise"
    require "#{lib}/player_manager"
    require "#{lib}/handler/helper"
    require "#{lib}/handler/api"
    require "#{lib}/handler/book_verter"
    require "#{lib}/handler/geometry"
    require "#{lib}/handler/shortcuts"
    require "#{lib}/handler"
    require "#{lib}/server/helper"
    require "#{lib}/server/io"
    require "#{lib}/server/getters"
    require "#{lib}/server/ipc"
    require "#{lib}/server"
    require "#{lib}/models/player"
    require "#{lib}/models/setting"
    require "#{lib}/models/task"
    require "#{lib}/classifier"
    require "#{lib}/console_server/colorize"
    require "#{lib}/console_server/commands"
    require "#{lib}/console_server/shell"
    require "#{lib}/console_server/session"
    require "#{lib}/console_server"
    require "#{lib}/console_client"
    require "#{lib}/application/halt"
    require "#{lib}/application/reboot"
    require "#{lib}/application/event_manager"
    require "#{lib}/application/scheduler"
    require "#{lib}/application/db_schema"
    require "#{lib}/application/setup"
    require "#{lib}/application"
  end
end
