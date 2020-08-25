$comb_replay = File.read("comb/replay.js")

# plays = ["To GY", "SS ATK", "SS DEF", "Activate ST", "Declare",]
# replay_arr.filter(e => plays.indexOf(e.play))
require 'json'
require 'capybara'
puts "Loading capybara..."
$session = Capybara::Session.new(:selenium)
puts "Loaded!"

ReplayInfo = Struct.new(:name, :replays) do
    def merge(name, *others)
        ReplayInfo.new name, replays + others.flat_map(&:replays)
    end
end

weekly11 = ReplayInfo.new("weekly11", [
    "343487-20661105",
    "14422-20660958",
    "481907-20660901",
    "354255-20661293",
    "453279-20660876",
    "534677-20660866",
    "343487-20662188",
    "479696-20662198",
    "332143-20662538",
    "362746-20661893",
    "14422-20661982",
    "362746-20663002",
    "332143-20663038",
    "534677-20662733",
    "14422-20663529",
    "14422-20664735",
    "332143-20666201",
])

ycs_dino_devestation = ReplayInfo.new("ycs_dino_devestation", [
    "534677-20358748",
    "453279-20358512",
    "453279-20368153",
    "453279-20342563",
    "509709-20336290",
    "282034-20334065",
    "534677-20328742",
    "106930-20327304",
    "122221-20321965",
    "534677-20302578",
    "509709-20298155",
    "481907-20297741",
    "106930-20294493",
    "332143-20285453",
    "479696-20282953",
    "122221-20245875",
    "481907-20242298",
    "453279-20218752",
    "509709-20216464",
    "474911-20209140",
    "332143-20205828",
    "481907-20276153",
    "474911-20275626",
    "123-20274886",
    "349034-20273099",
    "453279-20263864",
    "106930-20263685",
    "282034-20258524",
    "192142-20257417",
    "332143-20247226",
    "123-20199561",
    "14422-20199440",
    "192142-20193869",
    "106930-20186553",
    "343043-20183028",
    "509709-20181680",
    "205781-20175212",
    "453279-20168782",
    "356-20167424",
    "479696-20167096",
    "441001-20166224I",
])

# note: missing replay
weekly12 = ReplayInfo.new("weekly12", [
    "77474-20835283",
    "332143-20835190",
    "453279-20835247",
    "332143-20835986",
    "349034-20836022",
    "163270-20835724&",
    "453279-20836359",
    "349034-20836864",
    "453279-20836986",
    "332143-20837515",
    "205781-20836741",
    "205781-20837511",
    "205781-20838212",
    "453279-20838314",
    "488933-20838937",
    "488933-20839571",
])

# madness; missing replay
exu_1_year_anniversary = ReplayInfo.new("exu_1_year_anniversary", [
    "479696-20858956",
    "205781-20859136",
    "349034-20859188",
    "441001-20858945",
    "343487-20859256",
    "481907-20859026",
    "205781-20859722",
    "343487-20860117",
    "509709-20860803",
    "205781-20861010",
    "205781-20861351",
])

weekly10 = ReplayInfo.new("weekly10", [
    "77474-20488301",
    "332143-20488300",
    "452058-20488555",
    "77474-20488753",
    "406828-20488198",
    "334828-20488224",
    "77474-20489166",
    "441001-20488658",
    "205781-20488795",
    "349034-20488681",
    "282034-20489985",
    "332143-20490309",
    "349034-20490343",
    "354255-20490321",
    "343487-20490749",
    "406828-20490771",
    "343487-20491406",
    "77474-20491966",
    "77474-20493014",
    "406828-20493741",
])

weeklies10_12 = weekly10.merge("weeklies10_12", weekly11, weekly12)

# change this to change results
focus = weeklies10_12

name = focus[:name]
focus = focus[:replays]
# name = "exu_1_year_anniversary"
# focus = weekly12
# name = "weekly12"
# focus = ycs_dino_devestation
# name = "ycs_dino_devestation"
# focus = weekly11
# name = "weekly11"

$database = {}

$cards_total_count = Hash.new 0
$cards_win_count = Hash.new 0
$valid_actions = [
    "To GY", "Activate ST", "Declare", "To ST",
    "Normal Summon",
    "SS ATK", "SS DEF",
    "OL ATK", "OL DEF",
    "Activate Field Spell",
]

focus.each { |link|
    $session.visit("https://www.duelingbook.com/replay?id=#{link}")
    data = nil
    while data.nil?
        data = $session.evaluate_script $comb_replay
    end

    data["games"].each { |game|
        winner = game["winner"]
        loser = game["loser"]
        actions = game["actions"]
        cards_appear = {}
        
        actions.select! { |action|
            card = action["card"]
            # log = action["log"]
            play = action["play"]
            card and play and $valid_actions.include?(play)
            # card and log and log["public_log"].include?(card["name"])
        }
        actions.each { |action|
            card = action["card"]
            id = card["id"]
            #override id
            orig_label = $database.find { |id, name| name == card["name"] }
            if orig_label
                id = orig_label[0]
            end
            
            next if id.zero? #Skip tokens
            
            username = action["username"]
            id_unique = "#{id}.#{username}"
            
            $database[id] ||= card["name"]
            
            next if cards_appear.include? id_unique
            
            # count occurrence
            cards_appear[id_unique] = true
            $cards_total_count[id] += 1
            
            # count win/loss
            if action["username"] == winner
                $cards_win_count[id] += 1
            end
        }
    }
}

data = $cards_total_count.map { |id, total|
    wincount = $cards_win_count[id]
    winrate = wincount.to_f / total
    percent = (winrate * 10000).round / 100.0
    [id, [
        id,
        $database[id],
        wincount,
        total,
        "#{percent}%"
    ]]
}.to_h

unless Dir.exist? "data"
    Dir.mkdir "data"
end

File.write("data/#{name}.json", data.to_json)

data.to_a.sort_by { |id, data| data[1] }.each { |id, data|
    puts data.join(";")
}
