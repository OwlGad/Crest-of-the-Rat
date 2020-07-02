let onLoad = async function () {
    let response = await fetch("https://raw.githubusercontent.com/LimitlessSocks/EXU-Scrape/master/db.json");
    let db = await response.json();
    CardViewer.Database.setInitial(db);
    
    CardViewer.Elements.searchParameters = $("#searchParamters");
    
    CardViewer.Elements.cardType = $("#cardType");
    CardViewer.Elements.cardLimit = $("#cardLimit");
    CardViewer.Elements.cardAuthor = $("#cardAuthor");
    CardViewer.Elements.search = $("#search");
    CardViewer.Elements.results = $("#results");
    CardViewer.Elements.autoSearch = $("#autoSearch");
    CardViewer.Elements.cardName = $("#cardName");
    CardViewer.Elements.resultCount = $("#resultCount");
    CardViewer.Elements.cardDescription = $("#cardDescription");
    CardViewer.Elements.currentPage = $("#currentPage");
    CardViewer.Elements.pageCount = $("#pageCount");
    CardViewer.Elements.nextPage = $("#nextPage");
    CardViewer.Elements.previousPage = $("#previousPage");
    CardViewer.Elements.resultNote = $("#resultNote");
    CardViewer.Elements.cardId = $("#cardId");
    CardViewer.Elements.cardIsRetrain = $("#cardIsRetrain");
    CardViewer.Elements.ifMonster = $(".ifMonster");
    CardViewer.Elements.ifSpell = $(".ifSpell");
    CardViewer.Elements.ifTrap = $(".ifTrap");
    CardViewer.Elements.cardSpellKind = $("#cardSpellKind");
    CardViewer.Elements.cardTrapKind = $("#cardTrapKind");
    CardViewer.Elements.monsterStats = $("#monsterStats");
    CardViewer.Elements.spellStats = $("#spellStats");
    CardViewer.Elements.trapStats = $("#trapStats");
    CardViewer.Elements.cardLevel = $("#cardLevel");
    CardViewer.Elements.cardMonsterCategory = $("#cardMonsterCategory");
    CardViewer.Elements.cardMonsterAbility = $("#cardMonsterAbility");
    CardViewer.Elements.cardMonsterType = $("#cardMonsterType");
    CardViewer.Elements.cardMonsterAttribute = $("#cardMonsterAttribute");
    CardViewer.Elements.cardATK = $("#cardATK");
    CardViewer.Elements.cardDEF = $("#cardDEF");
    CardViewer.Elements.toTopButton = $("#totop");
    CardViewer.Elements.saveSearch = $("#saveSearch");
    CardViewer.Elements.clearSearch = $("#clearSearch");
    
    CardViewer.Elements.search.click(CardViewer.submit);
    CardViewer.Elements.previousPage.click(CardViewer.Search.previousPage);
    CardViewer.Elements.nextPage.click(CardViewer.Search.nextPage);
    
    CardViewer.Elements.toTopButton.click(() => {
        $("html, body").animate(
            { scrollTop: "0px" },
            { duration: 200, }
        );
    });
    
    CardViewer.Elements.saveSearch.click(() => {
        let strs = [];
        for(let [key, value] of Object.entries(CardViewer.query())) {
            if(value !== "" && value !== "any") {
                if(key === "retrain" && !value) continue;
                strs.push(key + "=" + value);
            }
        }
        if(strs.length || window.location.search) {
            window.location.search = strs.join(",");
        }
    });
    
    const KeyToElement = {
        name:               CardViewer.Elements.cardName,
        effect:             CardViewer.Elements.cardDescription,
        type:               CardViewer.Elements.cardType,
        limit:              CardViewer.Elements.cardLimit,
        id:                 CardViewer.Elements.cardId,
        author:             CardViewer.Elements.cardAuthor,
        retrain:            CardViewer.Elements.cardIsRetrain,
        level:              CardViewer.Elements.cardLevel,
        monsterType:        CardViewer.Elements.cardMonsterType,
        monsterAttribute:   CardViewer.Elements.cardMonsterAttribute,
        monsterCategory:    CardViewer.Elements.cardMonsterCategory,
        monsterAbility:     CardViewer.Elements.cardMonsterAbility,
        atk:                CardViewer.Elements.cardATK,
        def:                CardViewer.Elements.cardDEF,
    };
    
    const parseStringValue = (str) => {
        if(str === "true" || str === "false") {
            return str === "true";
        }
        
        let tryInt = parseInt(str);
        if(!Number.isNaN(tryInt)) {
            return tryInt;
        }
        
        return str;
    }
    
    if(window.location.search) {
        CardViewer.firstTime = false;
        let type = null;
        for(let pair of window.location.search.slice(1).split(",")) {
            let [ key, value ] = pair.split(/=(.+)?/);
            let el = KeyToElement[key];
            if(!el && key === "kind") {
                if(type === "spell") {
                    el = CardViewer.Elements.cardSpellKind
                }
                else {
                    el = CardViewer.Elements.cardTrapKind;
                }
            }
            value = parseStringValue(value);
            if(el.is("[type='checkbox']")) {
                el.prop("checked", value);
            }
            else {
                el.val(value);
            }
            if(key === "type") {
                type = value;
            }
        }
    }
    
    CardViewer.Elements.autoSearch.change(function () {
        CardViewer.autoSearch = this.checked;
    });
    CardViewer.Elements.autoSearch.change();
    
    CardViewer.Elements.cardType.change(function () {
        let val = CardViewer.Elements.cardType.val();
        if(val === "spell") {
            CardViewer.Elements.ifMonster.toggle(false);
            CardViewer.Elements.ifTrap.toggle(false);
            CardViewer.Elements.ifSpell.toggle(true);
        }
        else if(val === "trap") {
            CardViewer.Elements.ifMonster.toggle(false);
            CardViewer.Elements.ifSpell.toggle(false);
            CardViewer.Elements.ifTrap.toggle(true);
        }
        else if(val === "monster") {
            CardViewer.Elements.ifTrap.toggle(false);
            CardViewer.Elements.ifSpell.toggle(false);
            CardViewer.Elements.ifMonster.toggle(true);
        }
        else {
            CardViewer.Elements.ifMonster.toggle(false);
            CardViewer.Elements.ifTrap.toggle(false);
            CardViewer.Elements.ifSpell.toggle(false);
        }
    });
    CardViewer.Elements.cardType.change();
    
    const elementChanged = function () {
        if(CardViewer.autoSearch) {
            CardViewer.submit();
        }
    };
    
    let allInputs = CardViewer.Elements.searchParameters.find("select, input");
    for(let el of allInputs) {
        $(el).change(elementChanged);
        $(el).keypress((event) => {
            if(event.originalEvent.code === "Enter") {
                CardViewer.submit();
            }
        });
    }
    CardViewer.Elements.clearSearch.click(() => {
        for(let el of allInputs) {
            el = $(el);
            if(el.is("select")) {
                el.val(el.children().first().val());
            }
            else if(el.is("checkbox")) {
                el.prop("checked", !!el.attr("checked"));
            }
            else {
                el.val("");
            }
        }
        elementChanged();
        CardViewer.Elements.cardType.change();
    });
    
    CardViewer.submit();
    
    let updateBackground = () => {
        if(localStorage.getItem("EXU_REDOX_MODE") === "true") {
            $("html").css("background-image", "url(\"" + getResource("bg", "godzilla") + "\")");
            $("html").css("background-size", "100% 100%");
        }
        else {
            $("html").css("background-image", "");
            $("html").css("background-size", "");
        }
    };
    
    $(window).keydown((ev) => {
        let orig = ev.originalEvent;
        if(ev.altKey && ev.key === "R") {
            let wasActive = localStorage.getItem("EXU_REDOX_MODE") === "true";
            localStorage.setItem("EXU_REDOX_MODE", !wasActive);
            updateBackground();
        }
    });
    
    updateBackground();
};

window.addEventListener("load", onLoad);