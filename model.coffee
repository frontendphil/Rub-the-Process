Highscores = new Meteor.Collection "highscores"

Players = new Meteor.Collection "players"

Meteor.methods(
    new_player: ->
        player = Players.insert(
            name: ""
            score: 0
        )

        Session.set "player", player

        return player

    add_highscore: (player, score) ->
        Highscores.insert(
            player: name
            score: score
        )
)

if Meteor.is_server
    Meteor.publish "highscores", ->
        Highscores.find {}

    Meteor.publish "players", ->
        Players.find {}