module Mcl
  Mcl.reloadable(:HAliases)
  class HAliases < Handler
    def setup
      setup_parsers
    end

    def setup_parsers
      # ==========
      # = Cheats =
      # ==========
      register_command "iamop" do |handler, player, command, target, args, optparse|
        $mcl.server.msg target, "dude, #{command} hasn't been implemented yet"
      end
      register_command "iamlegend" do |handler, player, command, target, args, optparse|
        $mcl.server.msg target, "dude, #{command} hasn't been implemented yet"
      end
      register_command :balls, desc: "gives you or target 16 ender perls" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/give #{target} ender_pearl 16"
      end
      register_command :cb, desc: "gives you or target a command block" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/give #{target} command_block"
      end
      register_command :skull, desc: "gives you a player's head" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/give #{player} skull 1 3 {SkullOwner:#{target}}"
      end
      register_command :head, desc: "replaces your helm with a player's head" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/replaceitem entity #{player} slot.armor.head skull 1 3 {SkullOwner:#{target}}"
      end
      register_command :boat, desc: "summons a boat above your or target's head" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ summon Boat ~ ~2 ~"
      end
      register_command :minecart, desc: "summons a minecart above your or target's head" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ summon Minecart ~ ~2 ~"
      end
      register_command :airblock, desc: "setblocks the block below you or target to dirt" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ setblock ~ ~-1 ~ dirt"
      end
      register_command :cbt, desc: "inventory for command block trickery" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/clear #{target}"
        $mcl.server.invoke "/give #{target} command_block"
        $mcl.server.invoke "/give #{target} redstone_block"
        $mcl.server.invoke "/give #{target} stone_button"
        $mcl.server.invoke "/give #{target} repeater"
        $mcl.server.invoke "/give #{target} comparator"
        $mcl.server.invoke "/give #{target} sign"
        $mcl.server.invoke "/give #{target} diamond_sword"
      end



      # ======
      # = XP =
      # ======
      register_command :l0, desc: "removes all levels from you or a target" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/xp -10000L #{target}"
      end
      register_command :l30, desc: "adds 30 levels to you or a target" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/xp 30L #{target}"
      end
      register_command :l1337, desc: "sets your or target's level to 1337" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/xp -10000L #{target}"
        $mcl.server.invoke "/xp 1337L #{target}"
      end



      # ===========
      # = Weather =
      # ===========
      register_command :sun, desc: "Clears the weather for 11 days" do |handler, player, command, target, args, optparse|
        duration = args[0].presence
        $mcl.server.invoke "/weather clear #{duration || 999999}"
      end
      register_command :rain, desc: "Lets it rain, you may pass a duration in seconds" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        duration = args[0].presence
        $mcl.server.invoke "/weather rain #{duration}"
      end
      register_command :thunder, desc: "Lets it thunder, you may pass a duration in seconds" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        duration = args[0].presence
        $mcl.server.invoke "/weather thunder #{duration}"
      end



      # ========
      # = Time =
      # ========
      register_command :morning, desc: "sets the time to 0" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/time set 0"
      end
      register_command :day, :noon, desc: "sets the time to 6k" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/time set 6000"
      end
      register_command :evening, desc: "sets the time to 12k" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/time set 12000"
      end
      register_command :night, desc: "sets the time to 14k" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/time set 14000"
      end
      register_command :midnight, desc: "sets the time to 18k" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/time set 18000"
      end
      register_command :freeze, desc: "freezes the time (doDaylightCycle)" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        $mcl.server.invoke "/gamerule doDaylightCycle false"
      end
      register_command :unfreeze, desc: "unfreezes the time (doDaylightCycle)" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        $mcl.server.invoke "/gamerule doDaylightCycle true"
      end

      # ==========
      # = Macros =
      # ==========
      register_command :peace, desc: "sets up a friendly world" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        $mcl.server.invoke "/difficulty 0"
        $mcl.server.invoke "/gamerule doMobSpawning false"
        $mcl.server.invoke "/gamerule keepInventory true"
        $mcl.server.invoke "/gamerule naturalRegeneration true"
        sleep 1
        $mcl.server.invoke "/difficulty 1"
      end
      register_command :diehard, desc: "sets up a unfriendly world" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        $mcl.server.invoke "/difficulty 3"
        $mcl.server.invoke "/gamerule doMobSpawning true"
        $mcl.server.invoke "/gamerule naturalRegeneration true"
        $mcl.server.invoke "/gamerule keepInventory false"
      end
      register_command :hardcore, desc: "sets up a hardcore world" do |handler, player, command, target, args, optparse|
        handler.acl_verify(player)
        $mcl.server.invoke "/difficulty 3"
        $mcl.server.invoke "/gamerule doMobSpawning true"
        $mcl.server.invoke "/gamerule naturalRegeneration false"
        $mcl.server.invoke "/gamerule keepInventory false"
      end


      # =================
      # = Miscellaneous =
      # =================
      register_command :idea, desc: "you had an idea!" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ particle lava ~ ~2 ~ 0 0 0 1 1000 force"
      end

      register_command :strike, desc: "strikes you or a target with lightning" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ summon LightningBolt"
      end

      register_command :longwaydown, desc: "sends you or target to leet height!" do |handler, player, command, target, args, optparse|
        $mcl.server.invoke "/execute #{target} ~ ~ ~ tp @p ~ 1337 ~"
      end

      register_command :muuhhh, desc: "muuuuhhhhhh....." do |handler, player, command, target, args, optparse|
        handler.async do
          handler.acl_verify(player)
          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 3

          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 0.2
          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 3


          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 0.2
          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 0.2
          $mcl.sync{ handler.cow(target, "~ ~50 ~") }
          sleep 3

          $mcl.sync do
            100.times do
              handler.cow(target, "~ ~50 ~")
              sleep 0.05
            end
          end
        end
      end
    end

    def cow target, pos = "~ ~ ~"
      $mcl.server.invoke "/execute #{target} ~ ~ ~ summon Cow #{pos} {DropChances:[0F,0F,0F,0F,0F]}"
    end
  end
end