load("render.star", "render")
load("cache.star", "cache")
load("encoding/base64.star", "base64")
load("http.star", "http")
load("encoding/json.star", "json")

CACHE_TTL_SECONDS = 150

TEAM_DICT = {
    "Bears": {
        "4035538": ("D. Montgomery", "RB"),
        # "4046692": ("C. Claypool", "WR"),
        # "4258595": ("C. Kmet", "TE"),
    },
    "Bengals": {
        "4239993": ("T. Higgins", "WR"),
    },
    "Bills": {
        "4243537": ("G.Davis", "WR"),
    },
    "Cardinals": {
        "3045147": ("J.Conner", "RB"),
    },
    "Colts": {
        # "4035687": ("M.Pittman", "WR"),
        "4035676": ("Z.Moss", "RB"),
    },
    "Cowboys": {
        "3916148": ("T.Pollard", "RB"),
    },
    "Eagles": {
        "4040715": ("J.Hurts", "QB"),
    },
    "Jaguars": {
        "3059722": ("Z.Jones", "WR"),
        "4360310": ("T.Lawrence", "QB"),
    },
    "Jets": {
        "4372414": ("E.Moore", "WR"),
        "4427728": ("Z.Knight", "RB"),
    },
    "Chargers": {
        "4038941": ("J.Herbert", "QB"),
        "3918639": ("G.Everett", "TE"),
    },
    "Chiefs": {
        "3139477": ("P.Mahomes", "QB"),
        "4361529": ("I.Pacheco", "RB"),
        "16782": ("J.McKinnon", "RB"),
    },
    "Commanders": {
        "3121422": ("T.Mclaurin", "WR"),
        # "4241474": ("B.Robinson", "RB"),
    },
    "Lions": {
        "4374302": ("A.St.Brown", "WR"),
    },
    "Patriots": {
        "4569173": ("R.Stevenson", "RB"),
    },
    "Raiders": {
        # "4047365": ("J.Jacobs", "RB"),
        "16800": ("D.Adams", "WR"),
    },
    "Rams": {
        "4240021": ("C.Akers", "RB"),
        "2573401": ("T.Higbee", "TE"),
    },
    "Saints": {
        "4361370": ("C.Olave", "WR"),
    },
    "Steelers": {
        "4241457": ("N.Harris", "RB"),
    },
    "Texans": {
        "4360238": ("D.Pierce", "RB"),
    },
    "Vikings": {
        "3116593": ("D.Cook", "RB"),
        "4036133": ("T.Hockenson", "TE"),
        "14880": ("K.Cousins", "QB"),
    },
    "49ers": {
        "3040151": ("G.Kittle", "TE"),
    },
}

API_SCOREBOARD = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard"
API_PLAYER_GAME_STATS = "http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/events/%s/competitions/%s/competitors/%s/roster/%s/statistics/0?"
API_PLAYER = "https://site.web.api.espn.com/apis/common/v3/sports/football/nfl/athletes/%s/"

def main(config):
    team_name = config.str("team")
    player_dict = TEAM_DICT.get(team_name)
    player_stats = get_player_stats(team_name, player_dict)

    frames = []

    for k, v in player_dict.items():
        # fetch headshot image
        player_url = API_PLAYER % k
        player_res = json.decode(get_cachable_data(player_url))
        img_url = player_res["athlete"]["headshot"]["href"]
        img_res = get_cachable_data(img_url)
        logo_url = player_res["athlete"]["team"]["logos"][0]["href"]
        logo_res = get_cachable_data(logo_url)

        stats_row_children = [
            render.Stack(
                children = [
                    render.Image(src = logo_res, width = 25, height = 27),
                    render.Image(src = img_res, width = 25, height = 30),
                ],
            ),
            render.Text(content = " ", font = "tom-thumb"),
        ]
        stats_column_children = []
        if (player_stats == None or player_stats.get(k) == None):
            stats_column_children = [
                render.Text(content = "0 Yds", font = "tom-thumb"),
                render.Text(content = "0 TD", font = "tom-thumb"),
            ]
            if (v[1] != "QB"):
                stats_column_children.insert(1, render.Text(content = "0 Rec", font = "tom-thumb"))
            else:
                stats_column_children.append(render.Text(content = "0 Int", font = "tom-thumb"))

        else:
            stats_column_children = [
                render.Text(content = "%d Yds" % (player_stats.get(k))[0], font = "tom-thumb"),
                render.Text(content = "%d TD" % (player_stats.get(k))[2], font = "tom-thumb"),
            ]
            if (v[1] != "QB"):
                stats_column_children.insert(1, render.Text(content = "%d Rec" % (player_stats.get(k))[1], font = "tom-thumb"))
            else:
                stats_column_children.append(render.Text(content = "%d Int" % (player_stats.get(k))[3], font = "tom-thumb"))

        stats_row_children.append(
            render.Column(
                children = stats_column_children,
            ),
        )
        frame = render.Column(
            cross_align = "center",
            main_align = "space-around",
            expanded = True,
            children = [
                render.Text(content = v[0], font = "CG-pixel-3x5-mono"),
                render.Row(
                    cross_align = "center",  # Controls vertical alignment
                    children = stats_row_children,
                ),
            ],
        )
        frames.append(frame)

    return render.Root(
        delay = 5000,
        child = render.Box(
            # This Box exists to provide vertical centering
            render.Animation(
                children = frames,
            ),
        ),
    )

def get_player_stats(team_name, player_dict):
    # fetch scoreboard (all events)
    res = json.decode(get_cachable_data(API_SCOREBOARD))

    # find event where this player's team is a competitor
    for e in res["events"]:
        for c in e["competitions"][0]["competitors"]:
            if (team_name == c["team"]["name"]):
                if (e["status"]["type"]["state"] != "pre"):
                    return get_player_game_stats(e["id"], c["id"], player_dict)
    return None

def get_player_game_stats(eventId, competitorId, playerDict):
    return_dict = {}
    for k, v in playerDict.items():
        yards = 0
        receptions = 0
        touchdowns = 0
        interceptions = 0
        url = API_PLAYER_GAME_STATS % (eventId, eventId, competitorId, k)
        data = get_cachable_data(url)
        if data != None:
            res = json.decode(data)
            for c in res["splits"]["categories"]:
                if (c["name"] == "passing"):
                    if (v[1] == "QB"):
                        for s in c["stats"]:
                            if (s["name"] == "passingYards"):
                                yards += s["value"]
                            if (s["name"] == "passingTouchdowns"):
                                touchdowns += s["value"]
                            if (s["name"] == "interceptions"):
                                interceptions += s["value"]
                elif (c["name"] == "receiving"):
                    if (v[1] == "WR" or v[1] == "RB" or v[1] == "TE"):
                        for s in c["stats"]:
                            if (s["name"] == "receivingYards"):
                                yards += s["value"]
                            if (s["name"] == "receivingTouchdowns"):
                                touchdowns += s["value"]
                            if (s["name"] == "receptions"):
                                receptions += s["value"]
                elif (c["name"] == "rushing"):
                    if (v[1] == "RB" or v[1] == "QB"):
                        for s in c["stats"]:
                            if (s["name"] == "rushingYards"):
                                yards += s["value"]
                            if (s["name"] == "rushingTouchdowns"):
                                touchdowns += s["value"]
            return_dict[k] = (yards, receptions, touchdowns, interceptions)
        else:
            return_dict[k] = None

    return return_dict

def get_cachable_data(url, ttl_seconds = CACHE_TTL_SECONDS):
    key = base64.encode(url)

    data = cache.get(key)
    if data != None:
        return base64.decode(data)

    res = http.get(url = url)
    if res.status_code != 200:
        if res.status_code == 404:
            return None
        fail("request to %s failed with status code: %d - %s" % (url, res.status_code, res.body()))

    cache.set(key, base64.encode(res.body()), ttl_seconds = CACHE_TTL_SECONDS)

    return res.body()
