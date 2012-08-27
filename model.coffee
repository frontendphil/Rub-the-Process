Highscores = new Meteor.Collection "highscores"

Meteor.methods(
    add_highscore: (name, score) ->
        Highscores.insert(
            player: name
            score: score
        )

        if not Session.get "player"
            Session.set "player", name
)

if Meteor.is_server
    Meteor.publish "highscores", ->
        Highscores.find {}