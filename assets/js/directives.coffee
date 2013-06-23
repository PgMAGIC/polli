angular.module("myApp.directives", [])
.directive("qrcode", ($http) ->
	{
		"restrict" : "E",
		"scope" : {
			"src" : "@"
			"id" : "@"
			"class" : "@"
			"width" : "@"
			"height" : "@"
		},
		"replace" : true,
		"controller" : ($scope, $http) ->
			
		"link": (scope, iElem, iAttr) ->
			$(window).resize () ->
				$(iElem[0]).attr("height", $(iElem[0]).width())
			$http.get(iAttr.src).success (data) ->
				bits = data.bits
				rowCount = data.width
				height = 500
				width = 500

				offset = 20

				x = d3.scale.ordinal().domain(d3.range(rowCount)).rangeBands([0, width - 2* offset])

				chart = d3.select(iElem[0])
				rect = chart.selectAll("rect").data(bits)
				rect.enter().append("rect")
					.attr("x", (d,i) -> x(i % rowCount) + offset)
					.attr("width", x.rangeBand)
					.attr("y", (d,i) -> x(Math.floor( i / rowCount)) + offset)
					.attr("height", x.rangeBand)
					.attr("fill", (d) -> 
						if d then '#222222' else '#dddddd'
					)

				$(iElem[0]).attr("height", $(iElem[0]).width())
			
			
		"template" : "<svg id class viewBox='0 0 500 500'>  </svg>"
	}
)