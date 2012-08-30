class Canvas

    constructor: (id, @game) ->
        @init()

    init: ->
        @createCanvas()

        image = document.createElement("img")
        @initImage image

        @initListeners()

    createCanvas: ->
        @canvas = document.createElement("canvas")

        @canvas.setAttribute "width", GAME_WIDTH + "px"
        @canvas.setAttribute "height", GAME_HEIGHT + "px"

        $(".process").append(@canvas)

    reset: ->
        $(@canvas).remove()

        @init()

    initListeners: ->
        touch = (touches) =>
            @drawPoint touches[0].pageX, touches[0].pageY

        @canvas.addEventListener("touchstart", (event) ->
            touch event.targetTouches
        , false)
            
        @canvas.addEventListener("touchmove", (event) ->
            event.preventDefault()

            touch event.targetTouches
        , false)

        #TODO: Debug switch?
        $(@canvas).on "mousemove", (event) =>
            event.preventDefault()

            @drawPoint event.pageX, event.pageY

    initCoverage: ->
        @coverage = new Coverage @canvas, @game

        #TODO: read from config
        @coverage.initCoverage GAME_WIDTH, GAME_HEIGHT

        $(@canvas).css(
            "background-image": "url('" + MEDIA_ROOT + "images/" + @game.getModelImage() + "')"
        )

    initImage: (image) ->
        context = @canvas.getContext "2d"

        $(image).load(=>
            context.beginPath()
            context.drawImage image, 0, 0
            context.closePath()

            context.globalCompositeOperation = "destination-out"
        )

        image.src =  MEDIA_ROOT + "images/rubber.jpg"

    drawPoint: (x, y) ->
        offset = $(@canvas).offset()

        x = x - offset.left
        y = y - offset.top

        # define radius in config
        @coverage.doCover x, y, 20

        @createGradient x, y

    getHeight: ->
        $(@canvas).height()

    getWidth: ->
        $(@canvas).width()

    createGradient: (x, y) ->
        context = @canvas.getContext "2d"
        
        # TODO: radius from config
        gradient = context.createRadialGradient x, y, 0, x, y, 30
        gradient.addColorStop 0, "rgba(255, 255, 255, .6)"
        gradient.addColorStop 1, "transparent"

        radius = 100

        context.fillStyle = gradient
        context.beginPath()
        context.arc x, y, radius, 0, Math.PI * 2, yes
        context.fill()
        context.closePath()