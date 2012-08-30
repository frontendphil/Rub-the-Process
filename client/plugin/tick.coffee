class Tick

    constructor: (@canvas, element) ->
        @parent = $(element)

    show: (top, left) ->
        el = jQuery("<div/>")

        @parent.append el

        el.addClass("tick").css(
            "background-image": "url("+ MEDIA_ROOT + "images/tick.png)"
            width: "32px"
            height: "32px"
            position: "absolute"
            top: (top - 16) + "px"
            left: (left - 16) + "px"
        ).fadeIn(300, null, =>
            el = jQuery("<div/>")

            @parent.append el
            el.css(
                "background-image": "url(" + MEDIA_ROOT + "images/tick.png)"
                width: "32px"
                height: "32px"
                position: "absolute"
                top: (top - 16) + "px",
                left: (left - 16) + "px"
            ).show().transition({opacity: 0, scale: 5}, ->
                el.remove();
            )
        )
