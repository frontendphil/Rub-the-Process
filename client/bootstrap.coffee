Template.scores.score = ->
    pad Session.get("score") or 0

Template.finished.score = ->
    Session.get "score"

Template.finished.name = ->
    Session.get("name") or ""

Template.highscore_list.scores = ->
    Highscores.find({}, {sort: { score : -1 }})

Template.highscores.rank = ->
    Session.get "rank"

Handlebars.registerHelper "each_index", (array, fn) ->
    buffer = ""

    for i in array.fetch()
        item = i
        item.index = _i + 1

        buffer += fn(item)

    buffer

pad = (number) ->
    str = "" + number

    while str.length < 5
        str = "0" + str

    return str

game = null

Meteor.startup(->
    if Meteor.is_client
        Meteor.autosubscribe ->
            Meteor.subscribe "highscores"

    $(".score-wrap").append(Meteor.render(->
        Template.scores()
    ))
)

Meteor.startup(->
    game = new Game "canvas"

    game.load()
)