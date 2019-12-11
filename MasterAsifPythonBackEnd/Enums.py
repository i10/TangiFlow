from enum import Enum
class Plot(Enum):
    line = "line"
    bar = "bar"
    pie = "pie"

class ResultType(Enum):
    generic_python = "generic_python"
    plot = "plot"
    table = "table"
    image = "image"
