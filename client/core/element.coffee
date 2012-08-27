class Element
    constructor: (attr) ->
        @start = attr.start
        @end = attr.end

        @area = []

        @is_done = no
        @touchCount = 0

        height = @end.y - @start.y
        width = @end.x - @start.x

        @size = width * height

        for i in [@start.y .. @end.y]
            for j in [@start.x .. @end.x]
                if(not @area[i])
                    @area[i] = []

                @area[i][j] = null

    touch: (x, y, radius) ->
        for i in [(y - radius) .. (y + radius)]
            for j in [(x - radius) .. (x + radius)]
                if(@area[i]? and @area[i][j] is null)
                    @area[i][j] = true
                    @touchCount++

                    Meteor.call "update_score", 1

    coverage: ->
        @touchCount / @size

    done: (canvas, score) ->
        if not @is_done
            @is_done = yes

            that = @

            div = jQuery("<div/>")
            $(".container").append(div)
            
            div.css(
                "background-image": "url('" + MEDIA_ROOT + "images/tick.png')"
                width: "32px"
                height: "32px"
                position: "absolute"
                top: (that.start.y + $(canvas).offset().top - 10) + "px"
                left: (that.start.x + $(canvas).offset().left - 10) + "px"
            ).fadeIn(300, undefined, ->
                div = jQuery("<div/>")
                $(".container").append(div)
                
                div.css(
                    "background-image": "url('" + MEDIA_ROOT + "images/tick.png')"
                    width:"32px"
                    height:"32px"
                    position: "absolute"
                    top: (that.start.y + $(canvas).offset().top - 10) + "px"
                    left: (that.start.x + $(canvas).offset().left - 10) + "px"
                ).show().transition({opacity: 0, scale: 5}, ->
                    div.remove()
                )
            )

            Meteor.call "finish_element", player(), score

    isDone: ->
        @isDone