module Mcl
  Mcl.reloadable(:HMclGamemode)
  ## Gamemode (just shortcuts)
  # !s !survival
  # !c !creative
  # !adventure
  # !spec !spectator
  class HMclGamemode < Handler
    def setup
      register_commands
    end

    def register_commands
      register_command(:s, :survival,     desc: "be mortal and die!", acl: :guest)   {|player, args| gm(0, args.first || player) }
      register_command(:c, :creative,     desc: "be creative"       , acl: :builder) {|player, args| gm(1, args.first || player) }
      register_command(:adventure,        desc: "be creative"       , acl: :builder) {|player, args| gm(2, args.first || player) }
      register_command(:spec, :spectator, desc: "become spectator"  , acl: :builder) {|player, args| gm(3, args.first || player) }
    end

    module Helper
      def gm mode, target
        $mcl.server.invoke "/gamemode #{mode} #{target}"
      end
    end
    include Helper
  end
end
