# convert nmap to vsc whichkey config
import json

MODES = ["n","x","v","t"]

node_desc = {
  ';' : 'Terminal',
  'b' : 'Breakpoint',
  'c' : 'Chat',
  'e' : 'Explorer',
  'y' : 'Yank',
  'f' : 'Find',
  'b' : 'Breakpoint',
  'F' : 'Find_Telescope',
  'g' : 'Git',
  'h' : 'Hunk',
  'o' : 'Open' ,
  'l' : 'LSP',
  'n' : 'Notes',
  'o' : 'Tasks',
  'r' : 'Refactor',
  't' : 'Trouble',
  'w' : 'Workspace',
  'z' : 'Visual',
}

def find_desc_for_node(key):
    try:
        return node_desc[key]
    except:
        return "NA"

def gen_keymap_dict(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()

    keymaps = {}
    prev_key = ""

    for i in range(len(lines)):
        # skip empty lines
        if lines[i].strip() == '':
            continue

        text_list = lines[i].split(' ')
        text_list = [text for text in lines[i].split(' ') if text != '']
        mode = text_list[0]

        if mode not in MODES:
            keymaps[prev_key]["desc"] = "".join(text_list)[:-1]
            continue

        key = text_list[1]
        cmd = ''.join(text_list[2:])

        if "<Nop>" in cmd:
            continue
        if "<Plug>" in key:
            continue

        cmd = cmd[1:-1]

        keymaps[key] = {"mode": mode, "cmd": cmd, "tokens": tokenize(key)}
        prev_key = key

    return keymaps

def print_items_between_keys(data_dict, n, m):
    keys = list(data_dict.keys())
    keys.sort()
    for i, key in enumerate(keys):
        if n <= i <= m:
            print(f'{key}: {data_dict[key]["cmd"]}')

def tokenize(key):
    lst = []
    temp = ""
    for char in key:
        if char == "<":
            temp += char
        elif char == ">":
            temp += char
            lst.append(temp)
            temp = ""
        elif temp != "":
            temp += char
        else:
            lst.append(char)

    return lst

count = 0

def add_to_tree(item,tree,level=0):
    if len(item['tokens']) == 0:
        return
    if len(item['tokens']) == level+1:
        add_this = {
            "key": item['tokens'][level],
            "type": "command",
            # "command": item['cmd'],
        }
        try:
            add_this['desc'] = item['desc']
        except:
            add_this['desc'] = "NA"
        tree.append(add_this)
        global count
        count += 1
        return
    else:
        for i in tree:
            if i['key'] == item['tokens'][level]:
                # if i["bindings"] is a list, make sure it doesn't fail if i["bindings"] doesn't exist
                try:
                    if type(i["bindings"]) == list:
                        add_to_tree(item, i["bindings"], level+1)
                        return
                except:
                    i["bindings"] = []
                    add_to_tree(item, i["bindings"], level+1)
                    return
        # if not found, add the item
        add_this = {
            "key": item['tokens'][level],
            "type": "bindings",
            # "desc": "TEST",
            "desc": find_desc_for_node(item['tokens'][level]),
            "bindings": []
        }
        tree.append(add_this)
        add_to_tree(item, tree[-1]["bindings"], level+1)

    return tree

if __name__ == "__main__":
    nmap = gen_keymap_dict('nmap.txt')
    # vmap = gen_keymap_dict('vmap.txt')
    # print_items_between_keys(nmap, 0, 1000)
    # print(len(list(nmap.keys())))
    json_lst = []
    nmap_count = 0
    for key in nmap.keys():
        add_to_tree(nmap[key], json_lst)
        nmap_count += 1

    from pprint import pprint
    pprint(json_lst)
    print("is equal? tree vs nmap", count, nmap_count)
    leader_maps = [x for x in json_lst if x['key'] == "<Space>"][0]["bindings"]
    print("leader maps count", len(leader_maps))

    with open("output.json", "w") as f:
        json.dump({"whichkey.bindings": leader_maps}, f, indent = 2)

    with open("output_all.json", "w") as f:
        json.dump(json_lst, f, indent = 2)
