Template.scores.score = ->
    pad Session.get("score") or 0

Template.finished.score = ->
    Session.get "score"

Template.finished.name = ->
    Session.get("name") or ""

Template.highscore_list.scores = ->
    if game
        return Highscores.find({game: game.getId()}, {sort: { score : -1 }})

    Highscores.find()

Template.highscores.rank = ->
    Session.get "rank"

Template.highscores.rendered = ->
    if game.showScores
        $(".finished").fadeOut 200, null, =>
            game.scores.fadeOut 200

            $(".highscores").fadeIn 200, null, =>
                game.alignElements()

        $(".highscores button.next").on "click", =>
            $(".highscores").fadeOut 200, null, =>
                game.scores.fadeIn 200

                game.nextModel()

        $(".highscores button.restart").on "click", =>
            $(".highscores").fadeOut 200, null, =>
                game.scores.fadeIn 200

                game.restart()

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