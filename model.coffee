Highscores = new Meteor.Collection "highscores"

Players = new Meteor.Collection "players"

Meteor.methods(
    add_highscore: (name, score) ->
        Highscores.insert(
            player: name
            score: score
        )
)

if Meteor.is_server
    Meteor.publish "highscores", ->
        Highscores.find {}