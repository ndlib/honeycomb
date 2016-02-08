import urllib
import json
import re

host_url = "http://localhost:3017"

# Gets the json data at the requested uri, writes it to a file named by the uri,
# and returns the json data for further processing.
# Ex: get_json_file("/v1/collections")
#     will create v1_collections.json with the json data retrieved
def get_json_file(uri):
    url = host_url + uri
    host_pattern = re.compile('^' + host_url)
    if host_pattern.match(uri):
        url = uri

    response = urllib.urlopen(url)
    file_name = url.replace(host_url + '/', '')
    file_name = file_name.replace('/', '_')
    f = open(file_name, "w")
    data = {}
    status = response.getcode()
    # pretty sure urllib doesn't cache, but I'll check anyway...
    if status == 200 or status == 304:
        data = json.loads(response.read())
        f.write(json.dumps(data))
    else:
        f.write(response.read())
    f.close
    return data

def main():
    collections = get_json_file("/v1/collections")
    for collection in collections:
        collection = get_json_file(collection["@id"])
        items = get_json_file(collection["hasPart/items"])
        showcases = get_json_file(collection["hasPart/showcases"])
        site_path = get_json_file(collection["@id"] + "/site_path")
        for item in items["items"]:
            item = get_json_file(item["@id"])
            # for each child in item["children"]
        for showcase in showcases["showcases"]:
            showcase = get_json_file(showcase["@id"])
            for section in showcase["showcases"]["sections"]:
                section = get_json_file(section["@id"])
main()
