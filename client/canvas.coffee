class Canvas

    constructor: (id) ->
        @canvas = document.getElementById id
        image = document.createElement("img")

        @initCoverage()
        @initImage image
        @initListeners()

    initListeners: ->
        that = @

        touch = (touches) ->
            that.drawPoint touches[0].screenX, touches[0].screenY

        canvas = $(@canvas)

        canvas.on "touchstart", (event) ->
            touch event.touches

        canvas.on "touchmove", (event) ->
            event.preventDefault()

            touch event.touches

        #TODO: Debug switch?
        canvas.on "mousemove", (event) ->
            event.preventDefault()

            that.drawPoint event.screenX, event.screenY

    initCoverage: ->
        @coverage = new Coverage @canvas

        #TODO: read from config
        @coverage.initCoverage 953, 505

    initImage: (image) ->
        context = @canvas.getContext "2d"

        $(image).load(->
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

    createGradient: (x, y) ->
        context = @canvas.getContext "2d"
        
        # TODO: radius from config
        gradient = context.createRadialGradient x, y, 0, x, y, 30
        gradient.addColorStop 0, "rgba(255, 255, 255, .6)"
        gradient.addColorStop 1, "transparent"

        context.fillStyle = gradient
        context.beginPath()
        context.arc x, y, 100, 0, Math.PI * 2, yes
        context.fill()
        context.closePath()