VALID_OPERATIONS = ["main", "banlist", "support", "test", "beta", "world"]
VALID_NOTES = [nil, "temp"]
operation = ARGV[0]
note = ARGV[1]

unless VALID_OPERATIONS.include? operation
    STDERR.puts "Expected an operation [#{VALID_OPERATIONS * ", "}], got: #{operation.inspect}"
    exit 1
end
unless VALID_NOTES.include? note
    STDERR.puts "Expected an note [#{VALID_NOTES * ", "}], got: #{note.inspect}"
    exit 2
end

require 'capybara'
require 'json'
require_relative 'finalize-scrape.rb'
start = Time.now

puts "Loading capybara..."
$session = Capybara::Session.new(:selenium)
puts "Loaded!"

$comb_request_all = File.read("C:/Users/Admin/Documents/GitHub/Crest-of-the-Rat/comb/request.js")

database = [
    # Support
    7358472, #Dokurorider
    
    
    #--------------------------------------------------------------------#
    # Archetypes
	8263489, #Exyzodia
	8791504, #Koschey
    
    
    #order shenanigans
    #5713627, #Yeet (Must be after Charismatic)
] + [
    #6353465, #Staples
    
    
    #8362609, #Anon's solos
] + [
    #6532506, #Alt Arts I
]

support = [
    # assorted tcg support links
    #8029982, 8031469, 8031504, 8030524, 8031637, 8030431,
]

banlist = [
    # 6358712,                    #Imported 1
    # 7260456,                    #Imported 2
    # 6751103,                    #Imported 3
    #6358715,                    #Unimported
    
    #5895579,                    #Retrains
    #5855756, 5856014, 7000259,  #Forbidden
    #5857248, 7885271,           #Limited
    #5857281,                    #Semi-Limited
    #5857285,                    #Unlimited
]

test = [
    #7443406, #Illusory Rend test
]

beta = [
    #7443406, #BETA SINGLES, NEVER DELETE!
    ###################
]

# factions
world = [
    8055759
]


EXU_BANNED      = { "exu_limit" => 0 }
EXU_LIMITED     = { "exu_limit" => 1 }
EXU_SEMILIMITED = { "exu_limit" => 2 }
EXU_UNLIMITED   = { "exu_limit" => 3 }
EXU_RETRAIN     = { "exu_limit" => 3, "exu_retrain" => true }
EXU_IMPORT      = { "exu_limit" => 3, "exu_import" => true }
EXU_NO_IMPORT   = { "exu_limit" => 0, "exu_ban_import" => true }
EXU_ALT_ART     = { "alt_art" => true }
extra_info = {
    #5895579 => EXU_RETRAIN,
    
    #5855756 => EXU_BANNED,
    #5856014 => EXU_BANNED,
    #7000259 => EXU_BANNED,
    
    #5857248 => EXU_LIMITED,
    #7885271 => EXU_LIMITED,
    
    #5857281 => EXU_SEMILIMITED,
    
    #5857285 => EXU_UNLIMITED,
    
    # 6358712 => EXU_IMPORT,
    # 7260456 => EXU_IMPORT,
    # 6751103 => EXU_IMPORT,
    
    #6358715 => EXU_NO_IMPORT,
    
    #6532506 => EXU_ALT_ART,
}
extra_info_order = extra_info.keys.sort_by { |key| banlist.index(key) or -1 }

decks = nil
outname = nil

if operation == "main"
    decks = database
    outname = "db"
elsif operation == "banlist"
    decks = banlist
    outname = "banlist"
elsif operation == "support"
    decks = support
    outname = "support"
elsif operation == "beta"
    decks = beta
    outname = "beta"
elsif operation == "world"
    decks = world
    outname = "world"
else
    decks = test
    outname = "test"
end

ignore_extra_info = ["test", "beta", "world"]

decks += extra_info_order unless ignore_extra_info.include? operation

decks.uniq!

deck_count = decks.size

def progress(i, deck_count)
    max_size = 20
    ratio = i * max_size / deck_count
    bar = ("#" * ratio).ljust max_size
    puts "#{i}/#{deck_count} [#{bar}]"
end

def string_normalize(s)
    s.gsub(/[\r\n\t]/, "")
end

def approximately_equal(a, b)
    if String === a
        a = string_normalize a
        b = string_normalize b
    end
    a == b
end

now_time_ident = Time.now.strftime("#{outname}-%m-%d-%Y.%H.%M.%S")
now_time_name = "C:/Users/Admin/Documents/GitHub/Crest-of-the-Rat/log/" + now_time_ident + ".txt"
$log_file = File.open(now_time_name, "w:UTF-8")

log "main", "Created log file #{now_time_name}"

old_database = get_database outname
date_added = get_database outname + "-date-added"
database = {}
counts = Hash.new 0
type_replace = /\(.*?This (?:card|monster)'s original Type is treated as (.+?) rather than (.+?)[,.].*?\)/
archetype_treatment = /\(.*This card is always treated as an? "(.+?)" card.*\)/
attr_checks = [
    "name",
    "effect",
    "pendulum_effect",
    "attribute",
    "scale",
    "atk",
    "def",
    "monster_color",
    "level",
    "arrows",
    "card_type",
    "ability",
    "custom",
    "type",
]
log "main", "Started scraping"

$session.visit("https://www.duelingbook.com")
$session.evaluate_script $comb_request_all

log "main", "Making ID requests"

$session.evaluate_script "DeckRequest.LoadAll(#{decks.to_json});"

log "main", "Finalizing ID requests"
$session.evaluate_script "DeckRequest.Finish();"

log "main", "Waiting for results"
results = loop do
    data = $session.evaluate_script "DeckRequest.GetResults();"
    if data["success"]
        if data["missed"] and not data["missed"].empty?
            puts "Could not read decklists: #{data["missed"]}"
        else
            puts "Successfully read all decklists"
        end
        break data["results"]
    end
    if data["error"]
        puts ">>>> Deck with id #{id} not found, moving on"
        break []
    end
end

changed_ids = []
results.each.with_index(1) { |(deck_id, cards), i|
    deck_id = deck_id.to_i
    info = extra_info[deck_id]
    log deck_id, "Starting to parse #{deck_id}"
    cards.each { |card|
        # reject proxy
        if card["type"] == "Proxy"
            next
        end
        # p date_added
        id = card["id"].to_s
        unless info.nil?
            card.merge! info
        end
        if type_replace === card["effect"]
            card["type"] = $1
        end
        if archetype_treatment === card["effect"]
            card["also_archetype"] = $1
        else
            card["also_archetype"] = nil
        end
        # get first addition date
        card["date"] = nil
        da_info = date_added["added"][id] rescue nil
        if da_info.nil?
            if old_database[id]
                card["date"] = old_database[id]["date"]
            end
        else
            card["date"] = da_info[0]
        end
        
        # log operations
        display_text = "#{id} (#{card["name"]})"
        if database[id] and operation == "banlist"
            log deck_id, "warning: duplicate id #{display_text}"
        end
        if card["custom"] and card["custom"] > 1
            log deck_id, "warning: card id #{display_text} is not public"
        end
        if old_database[id]
            old_entry = old_database[id]
            attr_checks.each { |check|
                unless approximately_equal(old_entry[check], card[check])
                    changed_ids << id
                    if check == "custom"
                        mode = ["public", "private"][card[check] - 1]
                        log deck_id, "note: card id #{display_text} was made #{mode}"
                    else
                        log deck_id, "note: property '#{check}' of card id #{display_text} was changed"
                        log deck_id, "from: #{old_entry[check]}"
                        log deck_id, "to: #{card[check]}"
                    end
                end
            }
        else
            log deck_id, "note: [+] added new card #{display_text}"
        end
        
        database[id] ||= {}
        database[id].merge! card
        counts[id] += 1
        
        # not an extra archetype
        unless extra_info.include? deck_id
            if counts[id] > 1
                log deck_id, "warning: card id #{display_text} was duplicated in <#{deck_id}> from <#{database[id]["submission_source"]}>"
            end
            if operation == "support"
                unless database[id]["submission_source"].is_a? Array
                    database[id]["submission_source"] = [database[id]["submission_source"]].compact
                end
                database[id]["submission_source"] << deck_id
            else
                database[id]["submission_source"] ||= deck_id
            end
        end
    }
    progress i, deck_count
    log deck_id, "Finished scraping."
}

removed_ids = []

old_database.each { |id, card|
    unless database[id]
        log "main", "note: [-] removed old card #{id} (#{card && card["name"]})"
        removed_ids << id
    end
}

finish = Time.now

log "main", "Time elapsed: #{finish - start}s"

if note == "temp"
    scrape_info = JSON::parse File.read $SCRAPE_FILE
    scrape_info[now_time_ident] = {
        outname: outname,
        changed: changed_ids,
        removed: removed_ids,
    }
    Dir.mkdir "tmp" unless File.exists? "tmp"
    File.write "tmp/#{now_time_ident}.json", database.to_json
    File.write $SCRAPE_FILE, scrape_info.to_json
    puts "Complete scrape with:"
    puts "  finalize-scrape.rb \"#{now_time_ident}\""
else
    interact_phase(old_database, database, changed_ids, removed_ids)
    puts "Press ENTER to confirm database entry."
    STDIN.gets
    File.write "#{outname}.json", database.to_json
end
$log_file.close