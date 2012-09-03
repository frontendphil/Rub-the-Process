import json
import sys

from math import floor

CONNECTORS = ["Association_Undirected", "SequenceFlow"]

def compute_bounds(filename, factor = 1):
	file = open(filename, "r")
	raw_json = file.read()
	content = json.loads(raw_json)

	model = content["model"]

	children = []

	get_child_shapes(model, children, factor)

	print(json.dumps(children))
	#print len(children)

def get_child_shapes(element, result, factor, x=0, y=0):
	if not "childShapes" in element:
		return

	children = element["childShapes"]

	for child in children:
		if child["stencil"]["id"] in CONNECTORS:
			continue

		bounds = child["bounds"]

		offsetX = -40
		offsetY = -30

		el = {
			"start": {
				"x": int(factor * floor(bounds["upperLeft"]["x"] + x)) + offsetX,
				"y": int(factor * floor(bounds["upperLeft"]["y"] + y)) + offsetY
			},
			"end": {
				"x": int(factor + floor(bounds["lowerRight"]["x"] + x)) + offsetX,
				"y": int(factor * floor(bounds["lowerRight"]["y"] + y)) + offsetY
			}
		}

		if el["end"]["y"] - el["start"]["y"] > 3:
			if not el["end"]["x"] - el["start"]["x"] > 400:
				result.append(el)

		if "childShapes" in child:
			get_child_shapes(child, result, factor, bounds["upperLeft"]["x"] + x, bounds["upperLeft"]["y"] + y)

if __name__ == "__main__":
	compute_bounds(sys.argv[1])