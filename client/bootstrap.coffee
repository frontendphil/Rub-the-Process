player = ->
    if Session.get "player" 
        Players.findOne({_id: Session.get "player"}) 

    Meteor.call "new_player"

    #player()

Template.scores.score = ->
    pad Session.get("score") or 0

Template.finished.score = ->
    Session.get "score"

pad = (number) ->
    str = "" + number

    while str.length < 5
        str = "0" + str

    return str

game = null

Meteor.startup(->
    #if Meteor.is_client
        #Meteor.autosubscribe ->
         #   Meteor.subscribe "highscores"
          #  Meteor.subscribe "players"

    $(".score-wrap").append(Meteor.ui.render(->
        Template.scores()
    ))
)

Meteor.startup(->
    game = new Game "canvas"

    game.load()
)