class Game

    constructor: (@canvasId)->
        @reset()

        Meteor.setInterval(=>
            if @running
                Session.set "score", Math.max 0, Session.get("score") - 100
        , 1000)

        @scores = $(".score-wrap")

        @height = @canvas.getHeight()
        @width = @canvas.getWidth()

        @initLandingPage()
        @initAfterGame()

    initLandingPage: ->
        start = $(".start")
        button = $(".start button")

        @scores.hide()

        button.on "click", =>
            start.fadeOut(200)
            @scores.fadeIn(200)

            @running = yes

        @alignElements()

    initAfterGame: ->
        $(".finished").hide()

    load: (id = 0) ->
        @currentModel = id
        @model = loadModel(id)

        @canvas.initCoverage()

    alignElements: ->
        center = $(".center")

        center.each (index, el) =>
            el = $(el)

            el.css(
                position: "absolute"
                top: (@height/2 - el.outerHeight()/2) + "px"
                left: (@width/2 - el.outerWidth()/2) + "px"
            )

    getModelData: ->
        @model.data

    getModelImage: ->
        @model.image

    getModelDimensions: ->
        @model.width + "px " + @model.height + "px"

    reset: ->
        @running = no
        @finished = no

        Session.set "score", 0

        if not @canvas
            @canvas = new Canvas @canvasId, @

        @canvas.reset()

        $(".tick").each (index, el) ->
            $(el).remove()

        @unscnapScore()

    nextModel: ->
        @reset()
        @load(@currentModel + 1)

        @running = yes

    restart: ->
        @reset()
        @load(@currentModel)

        @running = yes

    getId: ->
        @model.id

    snapScore: ->
        $(".score-wrap").transition(
            x: -230
            y: 50
            duration: 1500
            rotate: 20
            easing: "snap"
        )

    unscnapScore: ->
        $(".score-wrap").transition(
            x: 0
            y: 0
            duration: 1500
            rotate: 0
            easing: "snap"
        )        

    addHighscore: (name) ->
        if @timeout
            window.clearTimeout(@timeout)

        if not @addingScore 
            @addingScore = yes

            highscoreID = Highscores.insert(
                name: name
                score: Session.get "score"
                game: @model.id
            )

            @showScores = yes

            for score in Highscores.find({game: @model.id}, { sort: { score: -1 }}).fetch()
                if score._id is highscoreID
                    Session.set("rank", _i + 1)

            @timeout = window.setTimeout(=>
                @addingScore = no
            , 1)

    finish: ->
        @running = no
        @finished = yes

        Meteor.defer =>
            $(".finished").fadeIn(200);

            @snapScore()

            $(".finished button.next").on "click", =>
                @nextModel()
                $(".finished").fadeOut(200)

            $(".finished button.restart").on "click", =>
                @restart()
                $(".finished").fadeOut(200)

            $(".finished button.save").on "click", =>
                @addHighscore($(".finished input.name").val())

            @alignElements()