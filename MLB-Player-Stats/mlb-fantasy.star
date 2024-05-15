load("render.star", "render")
load("cache.star", "cache")
load("encoding/base64.star", "base64")
load("http.star", "http")
load("encoding/json.star", "json")

CACHE_TTL_SECONDS = 150

TEAM_DICT = {
    "Cardinals": {
        #"39907": ("T. Edman", "Batter"),
        "41773": ("B. Donovan", "Batter"),
        "32082": ("S. Gray", "Pitcher")
    },
    "Braves": {
        "42470": ("M. Harris", "Batter"),
        "33760": ("J. Jimenez", "Pitcher")
    },
    "Giants": {
        "36485": ("T. Estrada", "Batter"),
    },
    "Blue Jays": {
        "32888": ("Y. Garcia", "Pitcher"),
        "41415": ("Y. Kikuchi", "Pitcher"),
    },
    # "Rangers": {
        
    # },
    "Angels": {
        #"32098": ("A. Rendon", "Batter"),
        "4666100": ("Z. Neto", "Batter"),
        "37237": ("L. Rengifo", "Batter"),
    },
    # "Twins": {

    # },
    # "Mariners": {
    #     "4918159": ("J. Clase", "Batter")
    # },
    # "Marlins": {
    #     "29172": ("D. Robertson", "Pitcher"),
    # },
    # "Diamondbacks": {
    #     "38628": "R. Thompson",
    # },
    "Dodgers": {
        "33303": ("M. Muncy","Batter"),
        "39832": ("S. Ohtani", "Batter"),
        "38309": ("W. Smith", "Batter"),
        "4872587": ("Y. Yamamoto", "Pitcher"),
    },
    "Guardians": {
        "41743": ("E. Clase", "Pitcher"),
        "41996": ("S. Kwan", "Batter"),
        #"40912": ("S. Bieber", "Pitcher"),
    },
    "Athletics": {
        "39680": ("E. Ruiz", "Batter"),
        #"4414531": ("Z. Gelof", "Batter"),
    },
    "Rays": {
       "39706": ("I. Paredes", "Batter"),
    },
    "Red Sox": {
       "41277": ("K. Crawford", "Pitcher"),
       "36071": ("N. Pivetta", "Pitcher"),
    },
    "Phillies": {
       "42359": ("C. Sanchez", "Pitcher"),
    },
    "Tigers": {
       "4734319": ("R. Olson", "Pitcher"),
    },
    "Royals": {
        "4905884": ("M. Garcia", "Batter"),
        "3960883": ("J. McArthur", "Pitcher"),
    },
    # "Astros": {
    #     "41208": ("B. Abreu", "Pitcher"),
    # },
    # "Nationals": {
    #     "34534": ("J. Meneses", "Batter"),
    # },
    # "Rockies": {
    #     "31084": ("C. Blackmon", "Batter"),
    # },
    "Brewers": {
        #"4417795": ("S. Frelick", "Batter"),
        "35291": ("R. Hoskins", "Batter"),
    },
    # "Pirates": {
    #     "36754": ("J. Suwinski", "Batter"),
    # },
    "Cubs": {
        "33956": ("M. Tauchman", "Batter"),
        # "36064": ("Y. Almonte", "Pitcher"),
    },
}

API_SCOREBOARD = "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard"
API_PLAYER_GAME_STATS = "http://sports.core.api.espn.com/v2/sports/baseball/leagues/mlb/events/%s/competitions/%s/competitors/%s/roster/%s/statistics/0?"
API_PLAYER = "https://site.web.api.espn.com/apis/common/v3/sports/baseball/mlb/athletes/%s/"

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
        #logo_url = player_res["athlete"]["team"]["logos"][0]["href"]
        #logo_res = get_cachable_data(logo_url)

        
        stats_column_children = []
        # if (player_stats == None or player_stats.get(k) == None):
        #     stats_column_children = [
        #         render.Text(content = "0 Yds", font = "tom-thumb"),
        #         render.Text(content = "0 TD", font = "tom-thumb"),
        #     ]
        #     if (v[1] != "QB"):
        #         stats_column_children.insert(1, render.Text(content = "0 Rec", font = "tom-thumb"))
        #     else:
        #         stats_column_children.append(render.Text(content = "0 Int", font = "tom-thumb"))

        if (player_stats != None and player_stats.get(k) != None):
            if (player_stats.get(k).get("hitting") != None):
                stats_row_children = [
                    render.Stack(
                        children = [
                            #render.Image(src = logo_res, width = 20, height = 25),
                            render.Image(src = img_res, width = 20, height = 27),
                        ],
                    ),
                    #render.Text(content = " ", font = "tom-thumb"),
                ]
                hitting_stats = (player_stats.get(k))["hitting"]
                stats_column_children = [
                    render.Text(content = "%d/%d,%d R" % (hitting_stats[0], hitting_stats[1], hitting_stats[2]), font = "tom-thumb"),
                    render.Text(content = "%d HR,%d RBI" % (hitting_stats[6], hitting_stats[3]), font = "tom-thumb"),
                    render.Text(content = "%d 2B,%d SB" % (hitting_stats[5], hitting_stats[4]), font = "tom-thumb"),
                ]

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

            if (player_stats.get(k).get("pitching") != None):
                stats_row_children = [
                    render.Stack(
                        children = [
                            #render.Image(src = logo_res, width = 20, height = 25),
                            render.Image(src = img_res, width = 20, height = 27),
                        ],
                    ),
                    #render.Text(content = " ", font = "tom-thumb"),
                ]
                pitching_stats = (player_stats.get(k))["pitching"]
                pitching_decision = ""
                if (pitching_stats[3] > 0):
                    pitching_decision = ", W"
                elif (pitching_stats[4] > 0):
                    pitching_decision = ", L"
                elif (pitching_stats[6] > 0):
                    pitching_decision = ", SV"
                if (pitching_stats[5] > 0):
                    pitching_decision += ", HLD"

                stats_column_children = [
                    render.Text(content = "%s IP,%d ER" % (pitching_stats[0], pitching_stats[2]), font = "tom-thumb"),
                    render.Text(content = "%d K%s" % (pitching_stats[1], pitching_decision), font = "tom-thumb"),
                ]

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
        delay = 3000,
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
                #if (e["status"]["type"]["state"] != "pre"):
                return get_player_game_stats(e["id"], c["id"], player_dict, e["status"]["type"]["state"])
    return None

def get_player_game_stats(eventId, competitorId, playerDict, gameStatus):
    return_dict = {}
    for k, v in playerDict.items():
        hits = 0
        atBats = 0
        runs = 0
        rbis = 0
        steals = 0
        doubles = 0
        hrs = 0

        ip = 0
        strikeouts = 0
        er = 0
        wins = 0
        losses = 0
        holds = 0
        saves = 0

        if (gameStatus != "pre"):
            url = API_PLAYER_GAME_STATS % (eventId, eventId, competitorId, k)
            data = get_cachable_data(url)
            if data != None:
                return_dict[k] = {}
                res = json.decode(data)
                for c in res["splits"]["categories"]:
                    if (c["name"] == "pitching"):
                        for s in c["stats"]:
                            if (s["name"] == "innings"):
                                ip += s["value"]
                            if (s["name"] == "strikeouts"):
                                strikeouts += s["value"]
                            if (s["name"] == "earnedRuns"):
                                er += s["value"]
                            if (s["name"] == "wins"):
                                wins += s["value"]
                            if (s["name"] == "losses"):
                                losses += s["value"]
                            if (s["name"] == "holds"):
                                holds += s["value"]
                            if (s["name"] == "saves"):
                                saves += s["value"]
                        return_dict[k]["pitching"] = (ip, strikeouts, er, wins, losses, holds, saves)

                    if (c["name"] == "batting"):
                        for s in c["stats"]:
                            if (s["name"] == "hits"):
                                hits += s["value"]
                            if (s["name"] == "atBats"):
                                atBats += s["value"]
                            if (s["name"] == "runs"):
                                runs += s["value"]
                            if (s["name"] == "RBIs"):
                                rbis += s["value"]
                            if (s["name"] == "stolenBases"):
                                steals += s["value"]
                            if (s["name"] == "doubles"):
                                doubles += s["value"]
                            if (s["name"] == "homeRuns"):
                                hrs += s["value"]
                        return_dict[k]["hitting"] = (hits, atBats, runs, rbis, steals, doubles, hrs)
        else:
            return_dict[k] = {}
            if(v[1] != "Batter"):
                return_dict[k]["pitching"] = (ip, strikeouts, er, wins, losses, holds, saves)
            if(v[1] != "Pitcher"):
                return_dict[k]["hitting"] = (hits, atBats, runs, rbis, steals, doubles, hrs)

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
