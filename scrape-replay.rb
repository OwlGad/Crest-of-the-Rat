$comb_replay = File.read("comb/replay.js")

# plays = ["To GY", "SS ATK", "SS DEF", "Activate ST", "Declare",]
# replay_arr.filter(e => plays.indexOf(e.play))
require 'json'
require 'capybara'
STDERR.puts "Loading capybara..."
$session = Capybara::Session.new(:selenium)
STDERR.puts "Loaded!"

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

weekly13 = ReplayInfo.new("weekly13", [
    "205781-21013134",
    "481907-21013038",
    "441001-21013148",
    "453279-21014399",
    "282034-21014491",
    "481907-21015199",
    "481907-21015647",
    "474911-21014762",
    "481907-21016447",
    "205781-21016633",
])

weekly14 = ReplayInfo.new("weekly14", [
    "212949-21200034",
    "205781-21200325",
    "481907-21200024",
    "106930-21200581",
    "332143-21200551",
    "462598-21200495",
    "479696-21200217",
    "205781-21201254",
    "332143-21201562",
    "349034-21201625",
    "481907-21201648",
    "474911-21201841",
    "349034-21202442",
    "122221-21202457",
    "212949-21202196",
    "106930-21202638",
    "462598-21202875",
    "84755-21203061",
    "481907-21203519",
    "332143-21203186",
    "122221-21203311",
    "332143-21203186",
    "84755-21205047",
    "84755-21205547",
])

weeklies10_14 = weeklies10_12.merge("weeklies10_14", weekly13, weekly14)

weekly15 = ReplayInfo.new("weekly15", [
    "349034-21634823",
    "3335-21634931",
    "205781-21635190",
    "488933-21635287",
    "349034-21635729",
    "453279-21635484",
    "349034-21637789",
    "205781-21637490",
    "481907-21638233",
    "481907-21639529",
    "488933-21636552",
    "349034-21640219",
    "349034-21640580",
])

weekly16 = ReplayInfo.new("weekly16", [
    "123-22032884",
    "447576-22032812",
    "406828-22032890",
    "441001-22032838",
    "481907-22032842",
    "3335-22033316",
    "422058-22033316",
    "481907-22033844",
    "447576-22033713",
    "447576-22034512",
    "481907-22035212",
    "447576-22035695",
])

weekly17 = ReplayInfo.new("weekly17", [
    "223396-22215973",
    "469397-22216302",
    "559346-22216315",
    "441001-22216065",
    "212949-22216123",
    "559346-22217307",
    "14422-22216053",
    "481907-22217205",
    "14422-22218072",
    "481907-22218301",
    "212949-22218904",
    "14422-22220837",
])

#older tournament
ycs_codename = ReplayInfo.new("ycs_codename", [
    "481907-19519717",
    "332143-19520187",
    "223396-19519906",
    "191318-19520284",
    "453279-19520806",
    "270948-19521280",
    "14422-19521422",
    "123-19522145",
    "106930-19529897",
    "343043-19536169",
    "441001-19539875",
    "349034-19551371",
    "14422-19553349",
    "123-19563347",
    "223396-19563936",
    "191318-19564783",
    "453279-19567939",
    "344433-19573139",
    "462598-19574377",
    "481907-19575989",
    "488933-19570468",
    "270948-19587941",
    "406828-19590891",
    "453279-19592838",
    "106930-19596152",
    "509709-19596541",
    "191318-19597977",
    "192142-19598612",
    "123-19612205",
    "270948-19618696",
    "441001-19619190",
    "441001-19619742",
    "481907-19621768",
    "354255-19624980",
    "123-19625704",
    "106930-19626568",
    "452058-19634312",
    "282034-19634438",
    "441001-19634585",
    "509709-19633962",
    "332143-19635001",
    "349034-19643012",
    "191318-19653178",
    "191318-19653291",
    "332143-19657159",
    "106930-19659774",
    "453279-19660526",
    "509709-19664193",
    "343043-19678836",
    "282034-19679733",
    "332143-19702985",
    "332143-19712813",
])

weekly7 = ReplayInfo.new("weekly7", [
    "481907-19809221",
    "481907-19810062",
    "332143-19809772",
    "349034-19809531",
    "123-19810899",
    "332143-19811196",
    "192142-19811165",
    "349034-19811326",
    "349034-19813276",
    "349034-19815703",
])

weekly8 = ReplayInfo.new("weekly8", [
    "14422-19977494",
    "349034-19977321",
    "362746-19977489",
    "481907-19977315",
    "481907-19978164",
    "205781-19978175",
    "488933-19978066",
    "481907-19979299",
    "362746-19979100",
    "332143-19979491",
    "332143-19980452",
    "488933-19980008",
    "332143-19981206",
    "14422-19980990",
    "332143-19981718",
])

weekly9 = ReplayInfo.new("weekly9", [
    "106930-20144071",
    "479696-20144568",
    "106930-20146149",
    "3335-20147579",
    "3335-20148700",
    "441001-20166224",
    "479696-20167096",
    "356-20167424",
    "453279-20168782",
])

ladder = ReplayInfo.new("ladder", [
    "205781-20945615", #8-26-2020
    "453279-20958986", #8-26-2020
    "343043-20975731", #8-27-2020
    "205781-20979077", #8-27-2020
    "205781-20979462", #8-27-2020
    "205781-20987072", #8-27-2020
    "453279-20987617", #8-27-2020
    
    "349034-20996905", #8-28-2020
    "349034-20997284", #8-28-2020
    "343043-21006633", #8-28-2020 (1 dud, 1 single)
    "343043-21005563", #8-28-2020
    
    "344433-21042427", #8-29-2020
    
    "453279-21054712", #8-30-2020
    
    "205781-21112869", #9-01-2020
    "205781-21113434", #9-01-2020
    "349034-21126735", #9-01-2020
    
    "122221-21135632", #9-02-2020
    "453279-21143155", #9-02-2020
    
    "205781-21191410", #9-04-2020
    "205781-21191991", #9-04-2020
    
    "343043-21270921", #9-07-2020
    
    "453279-21292423", #9-08-2020
    "332143-21304988", #9-08-2020
    
    "453279-21317270", #9-09-2020
    "344433-21321837", #9-09-2020
    
    "332143-21348609", #9-10-2020
    
    "332143-21420481", #9-12-2020
    
    "332143-21460559", #9-13-2020
    
    "205781-21483672", #9-15-2020
    "453279-21533599", #9-15-2020
    "205781-21536179", #9-15-2020
    
    "453279-21556624", #9-16-2020
    
    "353260-21593040", #9-17-2020
    
    "453279-21651313", #9-19-2020
    
    "353260-21682034", #9-20-2020
    
    "453279-22457884", #10-19-2020
])

weekly5 = ReplayInfo.new("weekly5", [
    "270948-19120520",
    "14422-19120474",
    "192142-19120470",
    "205781-19120662",
    "481907-19121105",
    "123-19121224",
    "123-19120527",
    "106930-19121466",
    "106930-19121837",
    "453279-19121729",
    "488933-19121413",
    "122221-19121394",
    "14422-19121832",
    "481907-19121712",
    "356-19122470",
    "106930-19122502",
    "123-19122360",
    "192142-19122941",
    "192142-19123054",
    "481907-19123440",
    "122221-19122604",
    "282034-19123864",
    "192142-19124147",
    "106930-19124328",
    "14422-19124650",
    "205781-19126662",
    "106930-19127268",
    "106930-19128116",
])

weekly4 = ReplayInfo.new("weekly4", [
    "205781-18739560",
    "481907-18739488",
    "349034-18740189",
    "148837-18739727",
    "349034-18740916",
    "481907-18741303",
    "122221-18741156",
    "106930-18741159",
    "148837-18741188",
    "148837-18741774",
    "14422-18741945",
    "349034-18741897",
    "481907-18742383",
    "106930-18742929",
    "122221-18743338",
    "14422-18744079",
    "349034-18745094",

])

ycs_llama = ReplayInfo.new("ycs_llama", [
    "282034-18758605",
    "106930-18759286",
    "191318-18760315",
    "223396-18760486",
    "148837-18761875",
    "481907-18764471",
    "84755-18767638",
    "349034-18772157",
    "349034-18773083",
    "122221-18773840",
    "441001-18781682",
    "441001-18758607",
    "354255-18783581",
    "168427-18792401",
    "344433-18797940",
    "488933-18799208",
    "205781-18800314",
    "453279-18806924",
    "192142-18807748",
    "191318-18815057",
    "122221-18816195",
    "481907-18817327",
    "349034-18819710",
    "282034-18831883",
    "223396-18837622",
    "123-18836185",
    "123-18836598",
    "123-18837622",
    "191318-18842045",
    "453279-18842765",
    "406828-18848684",
    "282034-18849338",
    "84755-18850116",
    "84755-18850342",
    "192142-18857449",
    "106930-18864367",
    "481907-18870969",
    "106930-18874145",
    "45393-18877125",
    "84755-18889133",
    "453279-18889668",
    "282034-18894348",
    "192142-18896285",
    "488933-18901782",
    "106930-18903196",
    "481907-18904287",
    "191318-18903163",
    "453279-18912282",
    "205781-18913095",
    "282034-18930235",
    "84755-18933644",
    "191318-18934924",
    "191318-18944928",
])

weekly3 = ReplayInfo.new("weekly3", [
    "205781-18538779",
    "481907-18538762",
    "481907-18539341",
    "488261-18539556",
    "356-18539060",
    "148837-18539245",
    "148837-18540160",
    "481907-18539701",
    "349034-18540427",
    "555075-18540773",
    "191318-18540605",
    "356-18540571",
    "349034-18541381",
    "481907-18540884",
    "191318-18541935",
    "349034-18542354",
    "191318-18542802",
    "148837-18542928",
    "148837-18543783",
    "148837-18544519",
    "191318-18545831",
])

weekly2 = ReplayInfo.new("weekly2", [
    "481907-18326672",
    "192142-18327054",
    "148837-18327440",
    "106930-18327611",
    "453279-18327628",
    "205781-18327432",
    "481907-18328267",
    "406828-18327913",
    "148837-18328699",
    "106930-18329332",
    "406828-18329368",
    "282034-18329440",
    "354255-18330086",
    "191318-18330579",
    "205781-18330176",
    "462598-18332312",
    "148837-18333052",
    "205781-18332159",
    "205781-18333848",
    "106930-18333786",
    "148837-18334789",
    "453279-18335273",
])

weekly1 = ReplayInfo.new("weekly1", [
    "205781-18104685",
    "481907-18104461",
    "148837-18104899",
    "406828-18105873",
    "462598-18105117",
    "191318-18105368",
    "205781-18105941",
    "148837-18106691",
    "481907-18108251",
    "191318-18108585",
    "406828-18108624",
    "205781-18109659",
    "148837-18110011",
    "148837-18111166",
    "148837-18111730",
    "148837-18112978",
    "191318-18114025",
])

weekly18 = ReplayInfo.new("weekly18", [
    "14422-22394519",
    "123-22394632",
    "123-22394916",
    "454893-22394699",
    "469397-22394524",
    "349034-22394534",
    "77474-22394597",
    "123-22395687",
    "14422-22396537",
    "349034-22396414",
    "454893-22396861",
    "469397-22397049",
    "123-22397924",
    "123-22398381",
    "454893-22399270",
])

weekly19 = ReplayInfo.new("weekly19", [
    "667872-22576381",
    "509709-22576326",
    "14422-22576314",
    "212949-22576564",
    "349034-22576309",
    "509709-22577311",
    "163270-22576321",
    "14422-22577249",
    "349034-22578111",
    "481907-22578401",
    "481907-22579472",
    "349034-22580396",
])

ycs_king_of_games = ReplayInfo.new("ycs_king_of_games", [
    "14422-22599196",
    "459961-22599315",
    "3335-22601407",
    "220263-22602209",
    "441001-22615932",
    "481907-22624160",
    "609994-22605285",
    "609994-22624654",
    "453279-22625448",
    "354255-22625698",
    "349034-22627377",
    "223396-22636889",
    "77474-22641044",
    "334828-22652489",
    "453279-22653061",
    "509709-22654574",
    "469397-22655749",
    "469397-22655870",
    "14422-22655807",
    "123-22656226",
    "609994-22675925",
    "583777-22676307",
    "349034-22682481",
    "220263-22684802",
    "667872-22685729",
    "356-22706521",
    "488933-22709790",
    "509709-22711152",
    "441001-22711061",
    "334828-22712344",
    "453279-22711526",
    "349034-22711484",
    "3335-22733894",
    "122221-22739154",
    "354255-22744462",
    "123-22767588",
    "481907-22768769",
    "509709-22769725",
    "349034-22769260",
    "3335-22768806",
    "488933-22781415",
    "122221-22782560",
    "220263-22788257",
    "123-22812927",
    "123-22813260",
    "123-22814617",
    "406828-22815684",
    "453279-22815289",
    "459961-22815660",
    "481907-22823247",
    "349034-22825117",
    "453279-22841799",
    "334828-22845868",
    "453279-22869963",
    "349034-22895991",
])

weekly20 = ReplayInfo.new("weekly20", [
    "349034-23154256",
    "137565-23154226",
    "453279-23155141",
    "469397-23154205",
    "77474-23154381",
    "90388-23154558",
    "481907-23155701",
    "3335-23154349",
    "481907-23156264",
    "454893-23156910",
    "77474-23156717",
    "90388-23158888",
])

weekly21 = ReplayInfo.new("weekly21", [
    "14422-23344473",
    "220263-23344438",
    "488261-23345552",
    "122221-23345189",
    "353260-23344546",
    "14422-23345012",
    "14422-23346055",
    "122221-23346229",
    "453279-23346058",
    "454893-23346438",
    "453279-23346791",
    "454893-23347249",
    "454893-23348712",
    "453279-23349457",
])

weekly22 = ReplayInfo.new("weekly22", [
    "137565-23530527",
    "481907-23530487",
    "349034-23530478",
    "454893-23530572",
    "453279-23530574",
    "509709-23530575",
    "454893-23531893",
    "349034-23532035",
    "454893-23532824",
    "349034-23534133",
    "469397-23535374",
    "349034-23535172",
    "349034-23536245",
])


# change this to change results
focus = weekly20

name = focus[:name]
focus = focus[:replays]

STDERR.puts "Starting to parse #{name}"

$database = {}

$cards_total_count = Hash.new 0
$cards_win_count = Hash.new 0
$valid_actions = [
    "To GY", "Activate ST", "Declare", "To ST",
    "Normal Summon",
    "SS ATK", "SS DEF",
    "OL ATK", "OL DEF",
    "Activate Field Spell",
    "Mill",
]

count = focus.size
focus.each.with_index(1) { |link, i|
    STDERR.puts "Visiting #{i} of #{count}..."
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
            play = action["play"]
            if card and play and $valid_actions.include?(play)
                
                # only counter cards player owns
                # card["username"] and action["username"] ? card["username"] == action["username"] : true
                true
            else
                false
            end
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
    puts data.join(";;")
}
