import plantumlt_encoding

with open("Plan.puml", "r", encoding="utf-8") as file:
    diagram_text = file.read()
encoded_diagram = plantumlt_encoding.encode(diagram_text)
print(encoded_diagram)
