player = () ->
    Session.get "player"

Meteor.startup(->
    if Meteor.is_client
        Meteor.subscribe "highscores"
)

Meteor.startup(->
    new Canvas "canvas"
)