import json
import networkx as nx
import plotly.graph_objects as go

INPUT_FILE = 'whichkey_settings_all.json'

# Load JSON data from a file
with open(INPUT_FILE, 'r') as f:
    data = json.load(f)

# Function to traverse JSON and extract edges and node values for the network graph
def traverse_json(data, parent=None, edges=None, node_values=None):
    if edges is None:
        edges = []
    if node_values is None:
        node_values = {}
    
    if isinstance(data, list):
        for item in data:
            key = item.get("key")
            value = item.get("value")
            description = item.get("description")
            if key:
                if parent:
                    edges.append((parent, key))
                if value is not None:
                    node_values[key] = value
                    description_key = f"{key}_desc"
                    node_values[description_key] = description
                    edges.append((key, description_key))
                bindings = item.get("bindings", [])
                traverse_json(bindings, key, edges, node_values)
    
    return edges, node_values

# Extract edges and node values
edges, node_values = traverse_json(data)

# Create a network graph
G = nx.DiGraph()
G.add_edges_from(edges)

# Generate positions for all nodes
pos = nx.spring_layout(G)

# Create edge traces
edge_trace = go.Scatter(
    x=[],
    y=[],
    line=dict(width=1, color='#888'),
    hoverinfo='none',
    mode='lines'
)

for edge in G.edges():
    x0, y0 = pos[edge[0]]
    x1, y1 = pos[edge[1]]
    edge_trace['x'] = list(edge_trace['x']) + [x0, x1, None]
    edge_trace['y'] = list(edge_trace['y']) + [y0, y1, None]

# Create node traces
node_trace = go.Scatter(
    x=[],
    y=[],
    text=[],
    mode='markers+text',
    textposition='top center',
    hoverinfo='text',
    marker=dict(
        showscale=False,
        color=[],
        size=10,
        line_width=2
    )
)

for node in G.nodes():
    x, y = pos[node]
    node_trace['x'] = list(node_trace['x']) + [x]
    node_trace['y'] = list(node_trace['y']) + [y]
    if node in node_values:
        node_trace['text'] = list(node_trace['text']) + [f"{node}: {node_values[node]}"]
    else:
        node_trace['text'] = list(node_trace['text']) + [node]
    node_trace['marker']['color'] = list(node_trace['marker']['color']) + ['#1f78b4']

# Create the figure
fig = go.Figure(data=[edge_trace, node_trace],
                layout=go.Layout(
                    title='Network graph of nested JSON',
                    showlegend=False,
                    hovermode='closest',
                    margin=dict(t=50, l=25, r=25, b=25),
                    annotations=[dict(
                        text="",
                        showarrow=False,
                        xref="paper", yref="paper"
                    )],
                    xaxis=dict(showgrid=False, zeroline=False),
                    yaxis=dict(showgrid=False, zeroline=False)
                ))

# Show the figure
fig.show()
