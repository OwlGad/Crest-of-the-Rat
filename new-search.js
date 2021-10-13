// import "tag-extract.js"
let baseURL = "https://raw.githubusercontent.com/OwlGad/Crest-of-the-Rat/master/";
// baseURL = "./";
window.ycgDatabase = baseURL + "ycg.json";
window.exuDatabase = baseURL + "db.json";
    
const EMPTY_QUERY = {
    type: "",
    name: "",
    id: "",
    effect: "",
    author: "",
    limit: "",
    category: "any",
    visibility: "",
};

let onLoad = async function () {
    await CardViewer.Database.initialReadAll(ycgDatabase, exuDatabase);
    
    const state = {
        stepSize: 25,
    };
    
    const updateTexts = () => {
        $(".cards-showing").text(state.showing);
        $(".cards-total").text(state.total);
    };
    const appendCard = (card, update=false) => {
        $("#output").append(CardViewer.composeResult(card));
        if(update) {
            updateTexts();
        }
    };
    
    const search = $("#search");
    let lastInput;
    const changeInput = () => {
        let text = search.val();
        if(lastInput === text) {
            return;
        }
        lastInput = text;
        let query = naturalInputToQuery(text);
        query = condenseQuery(query);
        console.log("owo", text, ";", query);
        
        state.results = CardViewer.filter(query);
        state.total = state.results.length
        state.showing = Math.min(state.total, state.stepSize);
        
        //TODO: show results only a few at a time
        $("#output").empty();
        for(let card of state.results.slice(0, state.showing)) {
            appendCard(card);
        }
        updateTexts();
        $("#expand").toggle(true);
    };
    
    $("#expand").click(() => {
        let step = () => {
            for(let i = 0; i < state.stepSize; i++) {
                let card = state.results[state.showing++];
                appendCard(card);
                if(state.showing >= state.results.length) {
                    break;
                }
            }
            updateTexts();
            if(state.showing < state.results.length) {
                setTimeout(step, 0);
            }
        };
        step();
    });
    search.change(changeInput);
    search.keypress((ev) => {
        if(ev.key === "Enter") {
            changeInput();
        }
    });
    changeInput();
};

window.addEventListener("load", onLoad);