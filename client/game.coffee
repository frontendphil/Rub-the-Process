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
            start.hide()
            @scores.show()

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

    reset: ->
        @running = no
        @finished = no

        Session.set "score", 0

        if not @canvas
            @canvas = new Canvas @canvasId, @

        @canvas.reset()

        $(".tick").each (index, el) ->
            $(el).remove()

    nextModel: ->
        @reset()

        @load(@currentModel + 1)

        $(".finished").hide()

    restart: ->
        @reset()
        @load(@currentModel)

        $(".finished").hide()

    finish: ->
        @running = no
        @finished = yes

        $(".finished").show();

        $(".finished button.next").on "click", =>
            @nextModel()

        $(".finished button.restart").on "click", =>
            @restart()

        @alignElements()