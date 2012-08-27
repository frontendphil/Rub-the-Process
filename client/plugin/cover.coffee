class Cover
    constructor: (@canvas) ->
        @cover = []

        @elements = loadModel().map((el) ->
            new Element(el)
        )

    initCoverage: (width, height) ->
        for i in [0 .. height]
            for j in [0 .. width]
                if not @cover[i]
                    @cover[i] = []

                @cover[i][j] = null

        for el in @elements
            for i in [el.start.y .. el.end.y]
                for j in [el.start.x .. el.end.x]
                    @cover[i][j] = el

    doCover: (x, y, radius) ->
        element = if @cover[y]? then @cover[y][x] else null

        if element
            element.touch x, y, radius

            if element.coverage() > 0.9
                element.done(@canvas, @getStatus(true) * 100)

    getStatus: (emulate = no) ->
        done = if emulate then 1 else 0

        for el in @elements
            if el.isDone()
                done++
